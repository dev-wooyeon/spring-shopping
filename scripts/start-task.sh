#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Usage: scripts/start-task.sh <task-number> <feature-action>" >&2
    echo "Example: scripts/start-task.sh 3 product-create" >&2
    exit 2
fi

task_number="$1"
feature_action="$2"

if ! [[ "$task_number" =~ ^[0-9]+$ ]]; then
    echo "task-number must be numeric." >&2
    exit 2
fi

branch_name="$(printf "codex/t%03d-%s" "$task_number" "$feature_action")"

echo "Creating branch: $branch_name"
git checkout -b "$branch_name"

echo "Branch ready."
echo "Next steps:"
echo "1) README 작업보드에서 상태를 In Progress로 바꾼다."
echo "2) docs/feature-design-template.md 기반으로 10분 설계를 남긴다."
echo "3) feat -> test -> refactor 순서로 커밋한다."
