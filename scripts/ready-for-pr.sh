#!/usr/bin/env bash
set -euo pipefail

echo "[1/2] Running tests..."
./gradlew test

echo
echo "[2/2] Ready checklist"
echo "- README 작업보드 상태를 In Progress 또는 Ready로 반영했는지 확인한다."
echo "- PR 템플릿의 정/반/합을 작성했는지 확인한다."
echo "- 테스트 결과를 PR 본문에 요약했는지 확인한다."
