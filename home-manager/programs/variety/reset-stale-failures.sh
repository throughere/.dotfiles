#!/usr/bin/env bash
set -uo pipefail

state_dir="$HOME/.config/variety/Downloaded"
[[ -d $state_dir ]] || exit 0

now=$(date +%s)

while IFS= read -r -d '' state; do
  python3 - "$state" "$now" <<'PY'
import json, sys

path, now = sys.argv[1], float(sys.argv[2])

try:
    with open(path) as f:
        state = json.load(f)
except Exception as e:
    print(f"skipping {path}: {e}", file=sys.stderr)
    sys.exit(0)

if state.get("last_download_failure", 0) <= now:
    sys.exit(0)

print(f"clearing future last_download_failure in {path}", file=sys.stderr)
state["last_download_failure"] = 0
with open(path, "w") as f:
    json.dump(state, f)
PY
done < <(find "$state_dir" -name state.json -print0)
