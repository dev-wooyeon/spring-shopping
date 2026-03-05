# spring-shopping

## 작업 보드
작업은 기능 단위로 쪼개서 관리한다.

| ID | Feature | 상태 | 브랜치 | PR | 테스트 | 정반합 노트 |
| --- | --- | --- | --- | --- | --- | --- |
| T001 | 회원/인증 코어 | Draft PR | `codex/t001-auth-core` | [#1](https://github.com/dev-wooyeon/spring-shopping/pull/1) | `./gradlew test` | 정: JWT+Interceptor로 단순하게 시작 / 반: 예외 응답 일관성 강화 필요 / 합: 공통 ErrorCode와 Handler로 고정 |
| T002 | 상품 도메인/API | Draft PR | `codex/t002-product-core` | [#2](https://github.com/dev-wooyeon/spring-shopping/pull/2) | `./gradlew test` | 정: 상품 CRUD와 검증 먼저 / 반: 비속어 검증 외부 의존성 리스크 / 합: 실패 코드 분리와 타임아웃 고정 |
| T003 | 위시리스트 도메인/API | Draft PR | `codex/t003-wish-core` | [#3](https://github.com/dev-wooyeon/spring-shopping/pull/3) | `./gradlew test` | 정: 사용자 중심 조회 우선 / 반: 중복 저장과 수량 예외 누락 가능 / 합: 중복 체크와 수량 검증을 서비스에 고정 |
| T004 | 문서 정리 | Draft PR | `codex/t004-docs-update` | [#4](https://github.com/dev-wooyeon/spring-shopping/pull/4) | 시나리오 수동 검증 | 정: 시나리오 재현 가능한 문서 / 반: 구현과 문서 불일치 가능 / 합: PR마다 문서 동기화 체크 |

## 운영 규칙
1. 작업 단위는 기능 단위로 고정한다.
2. 브랜치 이름은 `codex/t{번호}-{feature}-{action}` 패턴을 사용한다.
3. 커밋 메시지는 `type(domain): header` 형식으로 작성한다.
4. PR 본문은 [.github/pull_request_template.md](.github/pull_request_template.md)를 사용한다.
5. 완료 기준은 테스트 통과, 시나리오 검증, 리뷰 반영, 작업보드 업데이트를 모두 포함한다.

## 요청 명확화 규칙
요청이 추상적이면 작업 시작 전에 아래 네 가지를 먼저 잠근다.
1. 목표
2. 범위
3. 완료조건
4. 제약

네 가지 중 하나라도 비어 있으면 한 줄 질문으로 명확히 확인한다.

## 기능 1개 사이클
1. 작업보드에서 기능 상태를 `In Progress`로 변경한다.
2. 구현 전 10분 설계(입력/출력, 예외, 책임 경계, 테스트 포인트)를 남긴다.
3. 기능 구현은 `feat -> test -> refactor` 순서로 진행한다.
4. Draft PR을 열고 Codex 리뷰를 요청한다.
5. 리뷰 의견을 `반`, 최종 선택 이유를 `합`으로 기록한다.
6. `./gradlew test` 통과 후 Ready로 전환하고 Squash Merge로 마무리한다.
7. 머지 직후 작업보드와 노트를 업데이트한다.

## 운영 문서
- [워크플로우 플레이북](docs/workflow-playbook.md)
- [기능 설계 템플릿](docs/feature-design-template.md)
- [학습 노트](docs/note.md)

## 비즈니스 시나리오
1. 고객은 회원가입과 로그인을 통해 쇼핑 서비스에 진입한다.
2. 판매자는 상품을 등록하고, 필요할 때 상품 정보를 수정하거나 삭제한다.
3. 고객은 상품 목록과 상세 정보를 보며 관심 상품을 탐색한다.
4. 고객은 관심 있는 상품을 위시리스트에 추가하고, 원하지 않는 상품은 제거한다.
5. 고객은 자신의 위시리스트를 조회하며 관심 상품을 지속적으로 관리한다.

## 시나리오별 API (curl)

### Scenario 1. 회원가입 + 로그인
```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
EMAIL="scenario-user-$(date +%s)@example.com"
PASSWORD="Password1234"

echo "[register]"
REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
echo "$REGISTER_RESPONSE"

echo "[login]"
LOGIN_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
echo "$LOGIN_RESPONSE"
```

### Scenario 2. 상품 등록 + 수정 + 삭제
```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
SELLER_EMAIL="scenario-seller-$(date +%s)@example.com"
SELLER_PASSWORD="Password1234"

echo "[register seller]"
REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$SELLER_EMAIL\",\"password\":\"$SELLER_PASSWORD\",\"role\":\"SELLER\"}")
echo "$REGISTER_RESPONSE"
SELLER_TOKEN=$(echo "$REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

echo "[create product]"
CREATE_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/products" \
  -H "Authorization: Bearer $SELLER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"SpringShirt01","description":"Spring season shirt","price":19900,"imageUrl":"https://example.com/images/spring-shirt-01.jpg"}')
echo "$CREATE_RESPONSE"
PRODUCT_ID=$(echo "$CREATE_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["id"])')

echo "[update product]"
curl -sS -X PUT "$BASE_URL/api/products/$PRODUCT_ID" \
  -H "Authorization: Bearer $SELLER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"SpringShirt02","description":"Updated spring shirt","price":21900,"imageUrl":"https://example.com/images/spring-shirt-02.jpg"}'
echo

echo "[delete product]"
curl -sS -X DELETE "$BASE_URL/api/products/$PRODUCT_ID" \
  -H "Authorization: Bearer $SELLER_TOKEN"
echo
```

### Scenario 3. 상품 목록 조회 + 상세 조회
```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
SELLER_EMAIL="scenario-browse-seller-$(date +%s)@example.com"
SELLER_PASSWORD="Password1234"

REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$SELLER_EMAIL\",\"password\":\"$SELLER_PASSWORD\",\"role\":\"SELLER\"}")
SELLER_TOKEN=$(echo "$REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

echo "[create product for browse]"
CREATE_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/products" \
  -H "Authorization: Bearer $SELLER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"SpringJacket1","description":"Browse scenario product","price":39900,"imageUrl":"https://example.com/images/spring-jacket-01.jpg"}')
echo "$CREATE_RESPONSE"
PRODUCT_ID=$(echo "$CREATE_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["id"])')

echo "[list products]"
curl -sS "$BASE_URL/api/products"
echo

echo "[get product]"
curl -sS "$BASE_URL/api/products/$PRODUCT_ID"
echo
```

### Scenario 4. 위시리스트 추가 + 삭제
```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
EMAIL="scenario-wish-$(date +%s)@example.com"
PASSWORD="Password1234"
SELLER_EMAIL="scenario-wish-seller-$(date +%s)@example.com"
SELLER_PASSWORD="Password1234"

REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
TOKEN=$(echo "$REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

SELLER_REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$SELLER_EMAIL\",\"password\":\"$SELLER_PASSWORD\",\"role\":\"SELLER\"}")
SELLER_TOKEN=$(echo "$SELLER_REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

CREATE_PRODUCT_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/products" \
  -H "Authorization: Bearer $SELLER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"SpringCardig1","description":"Wish scenario product","price":32900,"imageUrl":"https://example.com/images/spring-cardigan-01.jpg"}')
PRODUCT_ID=$(echo "$CREATE_PRODUCT_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["id"])')

echo "[add wish]"
ADD_WISH_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/wishes" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"productId\":$PRODUCT_ID,\"quantity\":1}")
echo "$ADD_WISH_RESPONSE"
WISH_ID=$(echo "$ADD_WISH_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["wishId"])')

echo "[delete wish]"
curl -sS -X DELETE "$BASE_URL/api/wishes/$WISH_ID" \
  -H "Authorization: Bearer $TOKEN"
echo
```

### Scenario 5. 위시리스트 조회
```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
EMAIL="scenario-list-$(date +%s)@example.com"
PASSWORD="Password1234"
SELLER_EMAIL="scenario-list-seller-$(date +%s)@example.com"
SELLER_PASSWORD="Password1234"

REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
TOKEN=$(echo "$REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

SELLER_REGISTER_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/members/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$SELLER_EMAIL\",\"password\":\"$SELLER_PASSWORD\",\"role\":\"SELLER\"}")
SELLER_TOKEN=$(echo "$SELLER_REGISTER_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')

CREATE_PRODUCT_RESPONSE=$(curl -sS -X POST "$BASE_URL/api/products" \
  -H "Authorization: Bearer $SELLER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"SpringKnit001","description":"Wish list scenario product","price":27900,"imageUrl":"https://example.com/images/spring-knit-01.jpg"}')
PRODUCT_ID=$(echo "$CREATE_PRODUCT_RESPONSE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["id"])')

curl -sS -X POST "$BASE_URL/api/wishes" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"productId\":$PRODUCT_ID,\"quantity\":2}"
echo

echo "[list wishes]"
curl -sS "$BASE_URL/api/wishes" \
  -H "Authorization: Bearer $TOKEN"
echo
```

## 기능 목록
- [기능 목록 문서](docs/feature-list.md)
