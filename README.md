# RICP — Retail Infrastructure Configuration Portal

React + TypeScript / ASP.NET Core Web API / SQL Server `ABCASSET` 기반의 매장 IT 자산 운영 포털.

## 문서 읽는 순서
1. `docs/SCHEMA_REVIEW.md` — 실제 DDL 점검 결과 및 확정 전 질문
2. `docs/PRD.md` — 제품 목표·MVP·범위
3. `docs/ERD.md` — **업로드한 DDL 그대로** 테이블·컬럼·FK 명세
4. `docs/BUSINESS_RULES.md` — 소유자·분류·데이터 소유권 규칙
5. `docs/ARCHITECTURE.md` — 앱 구조 및 보안
6. `docs/DATA_SYNC.md` — 스케줄 동기화 + 관리자 수동 갱신
7. `docs/API_SPEC.md` — 조회 및 동기화 API 계약
8. `docs/SCREEN_SPEC.md` — 화면 정의
9. `docs/DESIGN.md` — 디자인 시스템
10. `tasks/EPIC-001-foundation.md` → `tasks/EPIC-004-dashboard.md` 순차 구현

`database/ABCASSET_original.sql`은 제공된 원본이며 임의로 수정하지 않는다. 동기화 프로시저 이름, 상태 코드값, Entra 앱 등록 값은 아직 미정이다. 추측으로 확정하지 않는다.

## 시작
Codex에게 `AGENTS.md`, `docs/SCHEMA_REVIEW.md`, `docs/PRD.md`, `docs/ERD.md`를 읽고 EPIC-001의 계획과 미결정 사항만 먼저 제시하도록 요청한다.

## 로컬 프로젝트 구성

새 로컬 폴더 또는 새 세션에서 이어갈 때는 [HANDOFF.md](docs/HANDOFF.md)를 먼저 읽으세요.

설치·실행 방법은 [LOCAL_SETUP.md](docs/LOCAL_SETUP.md), 검증 기록은
[TEST_RESULTS.md](docs/TEST_RESULTS.md)를 참고하세요.

```bash
bash scripts/bootstrap.sh
bash scripts/verify.sh
```

사용자 로컬 터미널에서 SDK/Node 설치와 빌드·테스트(13개)가 완료되었습니다.
npm 감사에서 발견된 moderate 2건은 Vitest 4.1.12 업데이트로 조치했으며, 온라인 재감사 결과 취약점 0건입니다.
DB 연결·Entra 인증·동기화는 아직 구현하지 않았습니다.

2026-11-02 로컬 이전 후 사용자 일반 터미널에서 기본 검증 스크립트 전체가 성공했습니다.
복원·빌드·타입 검사와 테스트 13개 통과를 확인했습니다(API TRX 직접 확인).
이후 사용자 터미널에서 Vitest 패치를 설치하고 프런트엔드 타입 검사·테스트 7개·빌드·온라인 감사를 재검증했습니다.
상세 내용은 [TEST_RESULTS.md](docs/TEST_RESULTS.md)를 참고하세요.
