# Data Sync Contract — scheduled + manual

## 기본 정책
- 실제 데이터 수집·적재는 기존 별도 스케줄러에서 수행한다.
- 포털 버튼은 **승인된 하나의 저장 프로시저**를 수동 실행 요청한다. 프로시저 이름은 아직 미정이다.
- 프런트엔드는 프로시저 이름을 전달할 수 없다. 백엔드 구성에 고정된 허용 프로시저만 실행한다.
- 실행 권한: `SyncAdmin` 역할(Entra ID 앱 역할/그룹 매핑 정책은 확정 필요).

## 프로시저 계약 확정표
| 항목 | 상태 |
|---|---|
| Schema/Procedure name | TBD |
| Parameters | TBD |
| Return code/output | TBD |
| Expected duration/timeout | TBD |
| Transaction/rollback semantics | TBD |
| Idempotency | TBD |
| Scheduler concurrency behavior | TBD |
| Last success timestamp source | TBD |

## 수동 실행 흐름
1. `POST /api/admin/sync-runs` (관리자 권한, CSRF/토큰 정책 준수).
2. 서버는 예약/수동 실행을 아우르는 중복 실행 잠금을 획득한다. SQL `sp_getapplock` 사용 가능하나 **예약 작업도 같은 잠금에 참여**해야 효과가 있다.
3. 실행 기록 생성(별도 `SYNC_RUN` 저장소/테이블은 **제안 사항**, 현 DDL에 없음).
4. 백그라운드 워커가 지정 프로시저 실행. 성공 여부는 프로시저의 명시적 결과/오류로 판정.
5. 상태 `Queued / Running / Succeeded / Failed / Rejected`와 시작·종료 시간, 오류 요약 저장.
6. UI는 `GET /api/admin/sync-runs/{id}` 폴링, 성공 시 목록/KPI 캐시 무효화.
7. 동일 시점 중복 실행 시 `409 Conflict` 또는 기존 실행 JobId 반환 정책을 확정한다.

## 실패/운영
- 작업 중 서버 재시작, 장시간 실행, SQL 연결 끊김, 부분 적재, 잠금 실패를 테스트한다.
- 원천 데이터는 실패 시 이전 정상 스냅샷을 유지하도록 프로시저 측 원자성/스테이징 전략 검토.
- 실행자 Entra Object ID, 요청 시각, 결과를 기록하되 토큰/비밀번호/상세 개인정보는 기록하지 않는다.
- 버튼 재시도와 자동 재실행은 무조건 허용하지 않고 프로시저의 멱등성 확인 후 정책 수립.

## 프로시저 실행 예시 (이름 확정 후에만 사용)
```csharp
// 예시: 실제 이름/파라미터/실행 방식 미확정
// await db.Database.ExecuteSqlRawAsync("EXEC dbo.<APPROVED_PROC>", cancellationToken);
```
