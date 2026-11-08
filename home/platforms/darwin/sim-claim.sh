usage() {
    echo "Usage: sim-claim [--device UDID] [--timeout SECONDS] -- command [args...]"
    echo "       sim-claim --open BOUND_AGENT_DEVICE BUNDLE_ID [open args...]"
    echo "Wait first-come-first-served for the shared simulator."
    echo "With --, run command while holding it (it sees SIM_CLAIM_UDID), then release."
    echo "With --open, open the app through an agent's bound command and keep the session."
    echo "Exit 75: still queued when the timeout ran out; re-run the same command to keep your place."
}

udid="${SIM_CLAIM_DEVICE:-4469D43E-D1C0-4E0B-9CAC-8684C5522DAF}"
timeout_s=""
bound=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --device) udid="$2"; shift 2 ;;
        --timeout) timeout_s="$2"; shift 2 ;;
        --open) bound="$2"; shift 2; break ;;
        --help|-h) usage; exit 0 ;;
        --) shift; break ;;
        *) break ;;
    esac
done
if [[ $# -eq 0 ]]; then usage >&2; exit 2; fi
# Agents' shell calls time out at 10 minutes, so they re-run within that budget.
if [[ -z "$timeout_s" ]]; then
    if [[ -n "$bound" ]]; then timeout_s=540; else timeout_s=3600; fi
fi

# Join T3's daemon so agents and scripts share one claim table; waits across daemons fail instantly.
t3_state="$HOME/.t3/userdata/device/agent-device"
state_root="${XDG_STATE_HOME:-$HOME/.local/state}/sim-claim"
state_dir="$state_root/daemon"
version=""
if [[ -f "$t3_state/daemon.json" ]]; then
    t3_pid="$(sed -n 's/.*"pid": *\([0-9]*\).*/\1/p' "$t3_state/daemon.json" | head -1)"
    if [[ -n "$t3_pid" ]] && kill -0 "$t3_pid" 2>/dev/null; then
        state_dir="$t3_state"
        version="$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$t3_state/daemon.json" | head -1)"
    fi
fi
if [[ -z "$version" ]]; then
    version="$(find "$HOME/.t3/tools/agent-device" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort -V | tail -1)"
fi
cli="$HOME/.t3/tools/agent-device/$version/node_modules/agent-device/bin/agent-device.mjs"
if [[ -z "$bound" && ( -z "$version" || ! -f "$cli" ) ]]; then
    echo "sim-claim: agent-device not found under ~/.t3/tools; open T3 once to install it." >&2
    exit 1
fi
mkdir -p "$state_dir"

ad() {
    AGENT_DEVICE_STATE_DIR="$state_dir" AGENT_DEVICE_NO_UPDATE_NOTIFIER=1 node "$cli" "$@"
}

# Queue: one ticket file per waiter, ordered by the enqueue time it holds.
# Waiters refresh their ticket's mtime; a ticket left alone for the grace period is dropped,
# which also lets an agent whose shell call timed out re-run and keep its place.
queue="$state_root/queue/$udid"
grace_s=180
mkdir -p "$queue"
if [[ -n "$bound" ]]; then
    ticket_name="$(basename "$(dirname "$bound")")"
else
    ticket_name="sim-claim-$(basename "$PWD")-$$"
fi
ticket="$queue/$ticket_name"
enqueue() {
    date +%s%N > "$ticket.tmp"
    mv "$ticket.tmp" "$ticket"
}
[[ -f "$ticket" ]] || enqueue
touch "$ticket"

queue_order() {
    local now file
    now="$(date +%s)"
    for file in "$queue"/*; do
        [[ -f "$file" && "$file" != *.tmp ]] || continue
        if (( now - $(stat -c %Y "$file") > grace_s )); then
            rm -f "$file"
            continue
        fi
        echo "$(head -1 "$file") $(basename "$file")"
    done | sort | cut -d' ' -f2
}

(
    while touch "$ticket" 2>/dev/null; do sleep 5; done
) &
refresher=$!
leave_queue() { kill "$refresher" 2>/dev/null || true; rm -f "$ticket"; }
stop_refreshing() { kill "$refresher" 2>/dev/null || true; }
if [[ -n "$bound" ]]; then
    trap stop_refreshing EXIT
else
    trap leave_queue EXIT
fi
trap 'exit 130' INT
trap 'exit 143' TERM

claim() {
    local wait_ms=$(( (deadline - $(date +%s)) * 1000 ))
    (( wait_ms > 30000 )) && wait_ms=30000
    (( wait_ms < 1000 )) && wait_ms=1000
    if [[ -n "$bound" ]]; then
        "$bound" open "$@" --wait "$wait_ms" --json 2>&1
    else
        ad open --platform ios --udid "$udid" --session "$ticket_name" --wait "$wait_ms" --json 2>&1
    fi
}

deadline=$(( $(date +%s) + timeout_s ))
last_position=""
while true; do
    order="$(queue_order)"
    position="$(grep -n -x -F "$ticket_name" <<<"$order" | cut -d: -f1 || true)"
    if [[ -z "$position" ]]; then
        # Dropped as stale (e.g. the Mac slept); rejoin at the back.
        enqueue
        continue
    fi
    if [[ "$position" == 1 ]]; then
        if out="$(claim "$@")"; then
            break
        fi
        if ! grep -q DEVICE_IN_USE <<<"$out"; then
            echo "$out" >&2
            leave_queue
            exit 1
        fi
        if [[ "$last_position" != holder ]]; then
            echo "sim-claim: next in line; waiting for the current holder:" >&2
            grep '"message"' <<<"$out" >&2 || true
            last_position=holder
        fi
        sleep 2
    else
        if [[ "$position" != "$last_position" ]]; then
            echo "sim-claim: queued at position $position, behind $(head -1 <<<"$order")" >&2
            last_position="$position"
        fi
        sleep 3
    fi
    if (( $(date +%s) >= deadline )); then
        echo "sim-claim: still queued after ${timeout_s}s; re-run the same command within ${grace_s}s to keep your place." >&2
        exit 75
    fi
done
leave_queue

if [[ -n "$bound" ]]; then
    echo "$out"
    echo "sim-claim: you hold the simulator; release it with device_close (shutdown:false) as soon as you're done." >&2
    exit 0
fi

echo "sim-claim: holding $udid as $ticket_name" >&2

# Any command counts as activity, so this keeps the idle expiry from releasing a long run.
(
    while sleep 300; do
        if ad appstate --session "$ticket_name" --json 2>&1 | grep -q SESSION_IDLE_EXPIRED; then
            echo "sim-claim: claim expired; another session may now use the simulator" >&2
            exit
        fi
    done
) &
heartbeat=$!

release() {
    kill "$heartbeat" 2>/dev/null || true
    ad close --session "$ticket_name" --json > /dev/null 2>&1 || true
}
trap release EXIT

SIM_CLAIM_UDID="$udid" "$@"
