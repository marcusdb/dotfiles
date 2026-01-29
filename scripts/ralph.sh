set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 <iterations>"
    exit 1
fi

for ((i=1; i<=$1; i++)); do
    echo "Iteration $i"
    echo "--------------------------------"
    result=$(claude --permission-mode acceptEdits -p "@plans/prd.json @progress.txt" \
        "Find the highest-priority feature to work on and work only on that feature.
        This should be the one YOU decide" \
        --output-format markdown)
    echo "$result"
    
    if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
        notify "Ralph Loop complete after $i iterations"
        exit 0
    fi

    sleep 1
done