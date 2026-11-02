confirmed=false
case "${1:-}" in
    --confirmed) confirmed=true ;;
    --help|-h)
        echo "Usage: $0 [--confirmed]"
        echo "Stop all device automation sessions on this Mac's default T3 daemon."
        echo "Keeps simulator app data. Other threads lose device control."
        echo "Use --confirmed only after explicit approval to take over."
        exit 0
        ;;
    "") ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
if [[ $# -gt 1 ]]; then
    echo "Expected at most one option." >&2
    exit 2
fi

if [[ "$confirmed" != true ]]; then
    if [[ ! -t 0 ]]; then
        echo "Confirmation required. Run in your terminal, or use --confirmed after explicit approval." >&2
        exit 2
    fi
    echo "Take over the previous simulator session?"
    echo "This stops all device automation on this Mac's default T3 daemon, including other threads."
    echo "Simulator app data is kept."
    read -r -p "Type take-over to proceed: " answer || { echo "Cancelled."; exit 1; }
    if [[ "$answer" != take-over ]]; then
        echo "Cancelled. No sessions were stopped."
        exit 1
    fi
fi

npx --yes agent-device@0.21.31 daemon stop --clean \
    --state-dir "$HOME/.t3/userdata/device/agent-device" || {
    status=$?
    echo "Cleanup failed (exit $status). Do not assume device ownership was released." >&2
    exit "$status"
}
echo "Cleanup complete. Reopen the device through T3 and verify interaction."
