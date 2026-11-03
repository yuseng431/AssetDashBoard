# Codex Agent Instructions

- 사용자 제공 DDL `database/ABCASSET_original.sql`이 기존 스키마의 사실 기준이다. 컬럼명, PK, FK, NULL 허용 여부를 임의로 바꾸지 않는다.
- 먼저 `docs/SCHEMA_REVIEW.md`, `docs/ERD.md`, `docs/BUSINESS_RULES.md`를 읽는다.
- 기술 스택: React + TypeScript, ASP.NET Core Web API, SQL Server, EF Core. LTS 버전은 착수 시 확인 후 고정한다.
- 프런트엔드에서 DB 직접 접근 금지. 인증은 Entra ID OIDC/OAuth2, API는 토큰 검증 및 역할별 인가.
- `ASSET_USER`는 자산 소유자 원천 마스터이며 Entra ID 사용자 테이블이 아니다.
- 원천 동기화 테이블에 일반 CRUD 기능을 임의로 만들지 않는다. 읽기 전용을 기본값으로 한다.
- 수동 동기화는 승인된 관리자만 실행한다. 프로시저명·파라미터·반환규격을 확인하기 전에는 실제 실행 코드를 활성화하지 않는다.
- 예약 실행과 수동 실행의 동시성 통제, 타임아웃, 감사 로그, 오류 처리, 멱등성 요구사항을 충족한다.
- 프로시저 실행에 입력된 이름을 문자열 결합하여 동적 SQL을 만들지 않는다. 고정된 허용 목록과 최소 권한 DB 계정 사용.
- 비밀값은 소스 코드나 문서에 저장하지 않는다. Entra 토큰과 개인정보를 로그에 남기지 않는다.
- DB 변경이 필요하면 원본 수정 대신 별도 검토용 마이그레이션을 제안하고 승인을 받는다.
- 구현마다 테스트를 추가하고 테스트 결과·미해결 이슈를 보고한다.
- 임의 Mock 값은 UI 샘플에서만 사용하고 실데이터로 오인되지 않도록 표시한다.
