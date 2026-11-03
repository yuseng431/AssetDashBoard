# API Spec (draft)

모든 엔드포인트는 `/api` 접두어 사용. 조회 API는 인증 필수. 응답 DTO는 기존 DDL 컬럼 기반.

| Method | Path | 용도 |
|---|---|---|
| GET | `/api/stores` | 매장 검색/페이지네이션 |
| GET | `/api/stores/{storeCd}` | 매장 상세 |
| GET | `/api/assets` | 자산 필터 검색(매장/소유자/카테고리/아이템/상태) |
| GET | `/api/assets/{assetCode}` | 자산 상세 |
| GET | `/api/asset-categories/tree` | 분류 계층 |
| GET | `/api/asset-items` | 아이템 검색 |
| GET | `/api/asset-owners` | 소유자 검색 |
| GET | `/api/dashboard/summary` | KPI 집계 |
| POST | `/api/admin/sync-runs` | 관리자 수동 동기화 시작 (202 Accepted + runId) |
| GET | `/api/admin/sync-runs/{runId}` | 실행 상태/결과 |
| GET | `/api/admin/sync-runs/latest` | 최근 성공/실패 이력 |

## 동기화 응답 예시
```json
{"runId":"example-id","status":"Queued","requestedAt":"2026-10-29T07:00:00Z"}
```

- 동시 실행 거절 시 409; 권한 부족 403; 유효하지 않은 요청 400; 예상치 못한 오류 500.
- 동기화 API는 원천 스키마에 없는 실행 이력 저장소가 확정되어야 완성 가능.
- 서버는 입력으로 저장 프로시저명을 받지 않는다.
