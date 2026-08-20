#!/usr/bin/env python3
"""Regression coverage for the read-only workflow-health classifier."""

from __future__ import annotations

import importlib.util
import pathlib
import unittest

MODULE_PATH = pathlib.Path(__file__).with_name("check_workflow_health.py")
SPEC = importlib.util.spec_from_file_location("check_workflow_health", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ClassifyRunsTest(unittest.TestCase):
    def test_excludes_own_monitor_run_and_classifies_states(self) -> None:
        summary = MODULE.classify_runs(
            [
                {
                    "id": 1,
                    "name": "Bounded repository workflow health",
                    "event": "schedule",
                    "status": "in_progress",
                },
                {
                    "id": 2,
                    "name": "Application CI",
                    "event": "push",
                    "status": "completed",
                    "conclusion": "success",
                },
                {
                    "id": 3,
                    "name": "Unit tests",
                    "event": "pull_request",
                    "status": "completed",
                    "conclusion": "failure",
                    "html_url": "https://example.invalid/runs/3",
                },
                {
                    "id": 4,
                    "name": "Build",
                    "event": "push",
                    "status": "queued",
                    "html_url": "https://example.invalid/runs/4",
                },
                {
                    "id": 5,
                    "name": "External dynamic update",
                    "event": "schedule",
                    "status": "completed",
                    "conclusion": "failure",
                },
            ],
            current_run_id="1",
        )

        self.assertEqual(summary["recent_run_count"], 3)
        self.assertEqual(summary["active_run_count"], 1)
        self.assertEqual(summary["non_passing_run_count"], 1)
        self.assertEqual(summary["non_passing_runs"][0]["id"], 3)
        self.assertEqual(summary["active_runs"][0]["id"], 4)


if __name__ == "__main__":
    unittest.main()
