usage() {
    echo "Usage: sim-claim [--device UDID] [--timeout SECONDS] -- command [args...]"
    echo "Queue for the shared simulator, run command while holding it, then release."
    echo "The command sees SIM_CLAIM_UDID. Defaults: shared iPhone 18 Pro, 3600s wait."
}

udid="${SIM_CLAIM_DEVICE:-4469D43E-D1C0-4E0B-9CAC-8684C5522DAF}"
timeout_s="${SIM_CLAIM_TIMEOUT:-3600}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --device) udid="$2"; shift 2 ;;
        --timeout) timeout_s="$2"; shift 2 ;;
        --help|-h) usage; exit 0 ;;
        --) shift; break ;;
        *) break ;;
    esac
done
if [[ $# -eq 0 ]]; then usage >&2; exit 2; fi

# Join T3's daemon so agents and scripts share one wait queue; waits across daemons fail instantly.
t3_state="$HOME/.t3/userdata/device/agent-device"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/sim-claim"
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
if [[ -z "$version" || ! -f "$cli" ]]; then
    echo "sim-claim: agent-device not found under ~/.t3/tools; open T3 once to install it." >&2
    exit 1
fi
mkdir -p "$state_dir"

ad() {
    AGENT_DEVICE_STATE_DIR="$state_dir" AGENT_DEVICE_NO_UPDATE_NOTIFIER=1 node "$cli" "$@"
}

session="sim-claim-$(basename "$PWD")-$$"
deadline=$(( $(date +%s) + timeout_s ))
announced=false
while true; do
    if out="$(ad open --platform ios --udid "$udid" --session "$session" --wait 60000 --json 2>&1)"; then
        break
    fi
    if ! grep -q DEVICE_IN_USE <<<"$out"; then
        echo "sim-claim: could not claim $udid:" >&2
        echo "$out" >&2
        exit 1
    fi
    if (( $(date +%s) >= deadline )); then
        echo "sim-claim: simulator still busy after ${timeout_s}s:" >&2
        grep '"message"' <<<"$out" >&2
        exit 75
    fi
    if [[ "$announced" != true ]]; then
        echo "sim-claim: simulator busy, waiting:" >&2
        grep '"message"' <<<"$out" >&2
        announced=true
    fi
    sleep 5
done
echo "sim-claim: holding $udid as $session" >&2

# Any command counts as activity, so this keeps the idle expiry from releasing a long run.
(
    while sleep 300; do
        if ad appstate --session "$session" --json 2>&1 | grep -q SESSION_IDLE_EXPIRED; then
            echo "sim-claim: claim expired; another session may now use the simulator" >&2
            exit
        fi
    done
) &
heartbeat=$!

release() {
    kill "$heartbeat" 2>/dev/null || true
    ad close --session "$session" --json > /dev/null 2>&1 || true
}
trap release EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

SIM_CLAIM_UDID="$udid" "$@"
