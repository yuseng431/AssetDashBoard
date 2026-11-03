# Architecture

```text
React + TypeScript (MUI, TanStack Query)
    │ HTTPS / OAuth2 access token
ASP.NET Core Web API (Entra ID JWT validation + role policies)
    │ EF Core read queries / dedicated stored procedure command
SQL Server ABCASSET (5 existing tables)
    │
External scheduler + approved sync stored procedure
```

## 설계
- Frontend: `src/frontend`, Backend: `src/backend`, Tests: `tests`.
- 도메인별 모듈: Stores, Assets, Categories, Owners, Dashboard, Sync.
- 목록은 서버 페이지네이션/필터링; DTO 반환; SQL 조회 파라미터화.
- 로그인은 Entra ID, 권한은 API 서버에서 검증. `ASSET_USER`를 인증 정보로 사용하지 않는다.
- 동기화 프로시저 호출 권한은 별도 최소 권한 DB Principal에만 부여하는 것을 검토한다.
- 긴 작업은 HTTP 요청에 묶지 않고 작업 시작 후 JobId 반환/상태 폴링을 권장한다.
- SQL Agent/외부 스케줄러와 수동 호출이 같은 자원을 갱신할 경우 공통 잠금 정책을 적용한다.
- 추가 테이블이 필요하면 `docs/SCHEMA_REVIEW.md`의 변경 승인 원칙을 따른다.

## EPIC-001 초기 구성 현황

- RICP.slnx: .NET 10 솔루션. API → Application/Infrastructure, Infrastructure → Application 참조.
- src/frontend: React/TypeScript/Vite 초기 화면. 프런트 테스트는 이 패키지의 tests/에 위치.
- tests/RICP.Api.Tests: DB 설정 없는 상태 API 및 업무 경로 비노출 테스트.
- 현재 API는 /api/health/live만 제공. 업무 API 추가 전 Entra 인증·인가 구현 필수.
- SDK/Node는 .tools/에 설치. scripts/verify.sh는 향후 CI 공통 진입점.
- MUI/TanStack Query, EF Core, Entra 및 CI 플랫폼 연결은 후속 구현 대상.
