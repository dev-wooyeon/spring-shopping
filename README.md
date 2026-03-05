# spring-shopping

## 필수 기능
### 회원 API
- [x] `POST /api/members/register` 회원 가입
- [x] `POST /api/members/login` 로그인

### 상품 API
- [x] `POST /api/products` 상품 생성
- [x] `GET /api/products/{productId}` 상품 조회
- [x] `PUT /api/products/{productId}` 상품 수정
- [x] `DELETE /api/products/{productId}` 상품 삭제
- [x] `GET /api/products` 상품 목록 조회

#### 상품 유효성 검사
- [x] 이름 최대 15자 제한
- [x] 허용 특수문자만 사용
- [x] PurgoMalum API 비속어 검사

### 위시 리스트 API
- [x] `POST /api/wishes` 위시 리스트 상품 추가
- [x] `DELETE /api/wishes/{wishId}` 위시 리스트 상품 삭제
- [x] `GET /api/wishes` 위시 리스트 상품 조회