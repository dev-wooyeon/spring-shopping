# 과제 4 기능 목록

## 작업 단위 맵
| 작업 ID | 작업명 | 포함 API | 상태 |
| --- | --- | --- | --- |
| T001 | 회원/인증 코어 | `POST /api/members/register`, `POST /api/members/login` | Ready |
| T002 | 상품 도메인/API | `POST /api/products`, `GET /api/products/{productId}`, `PUT /api/products/{productId}`, `DELETE /api/products/{productId}`, `GET /api/products` | Todo |
| T003 | 위시리스트 도메인/API | `POST /api/wishes`, `DELETE /api/wishes/{wishId}`, `GET /api/wishes` | Todo |
| T004 | 문서 정리 | README 시나리오, 기능 목록, 회고 노트 | Todo |

## 검증 순서
1. T001부터 T004 순서로 기능을 진행한다.
2. 각 작업은 브랜치 1개와 PR 1개로 마무리한다.
3. 머지 후 README 작업보드와 이 문서 상태를 함께 갱신한다.
