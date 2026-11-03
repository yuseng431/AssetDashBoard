# EPIC-001: foundation

## 목표
React/ASP.NET Core 솔루션 골격, Entra 인증·인가, SQL Server 읽기 연결, 환경 설정, 기본 CI 및 테스트. 기존 테이블 변경 금지.

## 사전 읽기
- `AGENTS.md`
- `docs/PRD.md`
- `docs/ERD.md`
- `docs/BUSINESS_RULES.md`
- `docs/ARCHITECTURE.md`
- `docs/DATA_SYNC.md`

## 완료 기준
- [ ] 구현 전에 변경 파일 및 미결정 사항을 제시한다.
- [ ] API 권한·예외·NULL 처리를 테스트한다.
- [ ] 제공 DDL과 실제 엔터티 매핑이 일치한다.
- [ ] 관련 문서와 테스트를 업데이트한다.
- [ ] 실행/테스트 결과를 기록한다.

## 2026-10-29 진행 기록

- 초기 솔루션, 프런트엔드, API 상태 엔드포인트, 테스트 및 설치 스크립트 작성.
- 에이전트 환경의 DNS 실패 후 사용자 로컬 터미널에서 도구 설치 및 복원 완료.
- 원본 DDL 변경/실행 및 DB 접속 없음.
- SDK/Node 설치, 패키지 복원·버전 잠금, .NET/Vite 빌드 및 테스트 13개 통과. npm moderate 2건 확인 필요.
- 인증·인가, EF 매핑, 비운영 DB 통합 검증, CI 서비스 연결은 미완료.
- 결과: docs/TEST_RESULTS.md. EPIC 전체 완료 기준은 아직 충족하지 않음.

## 2026-11-02 로컬 이전 후 검증

- 사용자 터미널에서 `scripts/verify.sh` 전체 성공, 테스트 13개 통과와 빌드·타입 검사 완료.
- Vitest 4.1.12 설치 후 사용자 터미널에서 타입 검사·테스트 7개·빌드 재검증 완료. 온라인 npm 감사 취약점 0건.
- 에이전트가 선언·잠금·설치 버전 일치를 확인. 기존 moderate 2건 조치 완료.
- Entra 인증·인가, EF 매핑, DB 통합 검증, CI는 여전히 구현 전이다.
