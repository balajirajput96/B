from __future__ import annotations

import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
errors: list[dict[str, str]] = []
workflow_count = 0
for path in sorted((root / "n8n-workflows").glob("*.json")):
    try:
        data = json.loads(path.read_text())
    except Exception as exc:
        errors.append({"file": str(path), "error": f"invalid_json: {exc}"})
        continue
    if path.name in {"manifest.json", "completion-assessment.json"}:
        if not isinstance(data, dict):
            errors.append({"file": str(path), "error": "report_not_object"})
        continue
    entries = data if isinstance(data, list) else [data]
    for index, entry in enumerate(entries):
        label = str(path) if len(entries) == 1 else f"{path}[{index}]"
        if not isinstance(entry, dict):
            errors.append({"file": label, "error": "workflow_entry_not_object"})
            continue
        workflow_count += 1
        missing = [key for key in ("name", "nodes", "connections") if key not in entry]
        if missing:
            errors.append({"file": label, "error": f"missing_keys: {missing}"})
        if not isinstance(entry.get("nodes"), list):
            errors.append({"file": label, "error": "nodes_not_list"})
        if not isinstance(entry.get("connections"), dict):
            errors.append({"file": label, "error": "connections_not_object"})
if errors:
    print(json.dumps({"workflow_count": workflow_count, "errors": errors}, indent=2))
    raise SystemExit(1)
print(json.dumps({"workflow_count": workflow_count, "errors": []}, indent=2))
