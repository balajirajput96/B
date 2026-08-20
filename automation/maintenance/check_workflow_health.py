#!/usr/bin/env python3
"""Summarize recent GitHub Actions states for the current repository.

This script is intentionally read-only. It never reruns, cancels, merges, pushes,
or changes workflow settings. The workflow wrapper applies a bounded scheduled run
count so recurring verification cannot continue indefinitely.
"""

from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request
from collections import Counter
from typing import Any

API_ROOT = "https://api.github.com"
NON_PASSING = {
    "failure",
    "timed_out",
    "action_required",
    "startup_failure",
    "cancelled",
}


def fail(message: str) -> int:
    print(f"::error::{message}", file=sys.stderr)
    return 1


def github_get(path: str, token: str) -> dict[str, Any]:
    request = urllib.request.Request(
        f"{API_ROOT}{path}",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
            "User-Agent": "repository-workflow-health-monitor",
        },
    )
    with urllib.request.urlopen(request, timeout=20) as response:
        return json.load(response)


def classify_runs(runs: list[dict[str, Any]], current_run_id: str | None) -> dict[str, Any]:
    relevant = [
        run
        for run in runs
        if str(run.get("id", "")) != current_run_id
        and run.get("event") in {"push", "pull_request", "workflow_dispatch"}
    ]
    active = [
        run
        for run in relevant
        if run.get("status") in {"queued", "in_progress", "waiting", "requested", "pending"}
    ]
    non_passing = [
        run
        for run in relevant
        if run.get("status") == "completed" and run.get("conclusion") in NON_PASSING
    ]
    conclusions = Counter(
        str(run.get("conclusion") or run.get("status") or "unknown") for run in relevant
    )
    return {
        "recent_run_count": len(relevant),
        "active_run_count": len(active),
        "non_passing_run_count": len(non_passing),
        "conclusions": dict(sorted(conclusions.items())),
        "active_runs": [
            {
                "id": run.get("id"),
                "name": run.get("name"),
                "event": run.get("event"),
                "status": run.get("status"),
                "url": run.get("html_url"),
            }
            for run in active
        ],
        "non_passing_runs": [
            {
                "id": run.get("id"),
                "name": run.get("name"),
                "event": run.get("event"),
                "conclusion": run.get("conclusion"),
                "url": run.get("html_url"),
            }
            for run in non_passing
        ],
    }


def main() -> int:
    repository = os.environ.get("GITHUB_REPOSITORY", "").strip()
    token = os.environ.get("GH_TOKEN", "").strip()
    current_run_id = os.environ.get("GITHUB_RUN_ID", "").strip() or None
    if not repository:
        return fail("GITHUB_REPOSITORY is required")
    if not token:
        return fail("GH_TOKEN is required")

    try:
        payload = github_get(
            f"/repos/{repository}/actions/runs?per_page=30", token
        )
    except urllib.error.HTTPError as error:
        return fail(f"GitHub Actions API request failed with HTTP {error.code}")
    except urllib.error.URLError as error:
        return fail(f"GitHub Actions API request failed: {error.reason}")

    runs = payload.get("workflow_runs")
    if not isinstance(runs, list):
        return fail("GitHub Actions API response did not include workflow_runs")

    summary = classify_runs(runs, current_run_id)
    print(json.dumps(summary, indent=2, sort_keys=True))
    print("### Repository workflow health", file=sys.stderr)
    print(f"Recent relevant runs: {summary['recent_run_count']}", file=sys.stderr)
    print(f"Active relevant runs: {summary['active_run_count']}", file=sys.stderr)
    print(f"Recent non-passing runs: {summary['non_passing_run_count']}", file=sys.stderr)
    print(
        "The monitor is observational; non-passing records require diagnosis in a reviewable repair branch.",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
