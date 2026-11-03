# RICP 작업 인계 — 2026-10-29

## 작업 순서 변경 — 2026-11-03

- 사용자가 GitHub 형상관리를 CI보다 먼저 구성하도록 요청했다.
- 대상 저장소: `https://github.com/yuseng431/AssetDashBoard.git`.
- 사용자 터미널에서 `git init -b main`과 `origin` 연결을 완료했다. 에이전트가 로컬 Git 상태와 원격 URL을 확인했다.
- 현재 `main`에는 커밋이 없고 커밋 작성자 이름·이메일도 미설정이다. 원격 조회의 종료 상태는 아직 확인하지 못했다.
- Git 제외 규칙이 SDK/캐시/node_modules/프런트엔드 빌드/API 테스트 결과에 적용됨을 확인했다. 최초 커밋·푸시는 아직 수행하지 않았다.
- 에이전트의 `git init -b main`은 `.git: Operation not permitted`로 실패했다.
  원격 조회는 `Could not resolve host: github.com`으로 실패했다. 이후 사용자가 일반 터미널에서 위 초기화를 완료했다.
- `.gitignore`에 SDK/캐시/node_modules/빌드 결과/테스트 결과/로컬 환경 파일 제외가 이미 있다.
- 일반 터미널에서 원격 이력 확인, 작성자 설정 및 최초 커밋·푸시가 필요하다.
  원격 기본 브랜치·기존 커밋·공개 여부는 아직 확인하지 못했으므로 최초 푸시 전에 확인한다.
- 중단된 CI 준비 작업으로 `scripts/environment.sh`의 local/system 도구 선택,
  `scripts/verify.sh`의 테스트 재복원 방지, `tests/test_environment.py`가 작성돼 있다.
  GitHub Actions 워크플로는 아직 생성하지 않았다. 관련 Python 테스트 총 8개 통과.
  CI 재개 시 이 변경을 검토하고 이어간다.

## 최신 재개 지점 — 2026-11-02

- 실제 로컬 복사 경로는 `/Users/yuseung/AI/Codex/Asset-Dashboard/Codex`이며 `.tools`, `.cache`, 잠금 파일이 존재한다.
- 에이전트 재검증: Python 2개·Vitest 7개 통과, TypeScript 검사와 프런트엔드/.NET Release 빌드 성공.
- 사용자 일반 터미널에서 16:03에 `scripts/verify.sh` 전체 성공: 복원·빌드·타입 검사 및 테스트 13개 통과. API 성공 TRX를 에이전트가 확인했다.
- 에이전트 환경의 복원 지연과 API 테스트 소켓 제한은 남아 있지만, 사용자 환경에서는 정상 실행됐다.
- 사용자 터미널에서 Vitest 4.1.12 패치를 설치하고 타입 검사·테스트 7개·빌드를 재검증했다. 온라인 npm 감사 결과 취약점 0건으로 기존 moderate 2건 조치 완료.
- 에이전트가 package.json, 잠금 파일, 실제 설치를 확인했으며 Vitest와 @vitest/mocker 모두 4.1.12다.
- Git 저장소는 여전히 없다. 원본 DDL 체크섬은 이전 기록과 같다.
- 상세 결과와 재현 명령은 `docs/TEST_RESULTS.md`의 2026-11-02 항목 참조.
- 다음 작업은 초기 화면/API 실통신 및 개발 서버 파일 변경 감지를 확인하고, Entra 등록·역할 계약을 확정하는 것이다. 최신 검증 결과는 `docs/TEST_RESULTS.md` 참조.

아래는 이전 시점의 인계 기록이다. 경로와 실행 결과는 위 최신 기록을 우선한다.

## 재개 지점

EPIC-001의 개발 도구 설치와 기본 프로젝트 구성·빌드·테스트까지 완료했다.
EPIC-001 전체가 완료된 것은 아니다. 사용자가 OneDrive 밖 로컬 폴더로 복사한 뒤
새 프로젝트에서 이어갈 예정이다. 이번 세션에서 실제 폴더 이동은 수행하지 않았다.

- 기존 경로: `/Users/yuseung/Library/CloudStorage/OneDrive-ABC-MARTKOREAInc/00. AI/Asset-Dashboard/Codex`
- 제안 경로: `/Users/yuseung/Projects/Asset-Dashboard` (아직 생성/복사 확인 안 됨)
- 원본은 유지하고 복사본에서 검증한다. `.tools`, `.cache` 등 숨김 폴더도 복사하면 기존 도구와 캐시를 활용할 수 있다.
- 개발 서버를 종료하고 복사한다. 잠금 파일은 반드시 유지한다.
- 로컬 이전은 동기화 부담을 줄이기 위한 선택이다. 네트워크 권한 문제 해결을 보장하지 않는다.

## 먼저 읽을 파일

`AGENTS.md`, `docs/SCHEMA_REVIEW.md`, `docs/ERD.md`, `docs/BUSINESS_RULES.md`,
`docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/DATA_SYNC.md`,
`tasks/EPIC-001-foundation.md`, `docs/LOCAL_SETUP.md`, `docs/TEST_RESULTS.md`.

## 완료한 작업과 검증 근거

- 프로젝트 내부 `.tools`에 Node.js 24.22.2, npm 11.19.1, .NET SDK 10.0.403 설치.
- `RICP.slnx`: API / Application / Infrastructure / API 테스트 프로젝트 구성.
- React 19.2.9, TypeScript 6.0.3, Vite 8.3.5, Vitest 4.1.11 고정.
- npm 및 NuGet 잠금 파일 생성. 최초 설치를 다시 하지 말고 현재 파일부터 확인한다.
- API: `GET /api/health/live`만 제공. `ok`는 프로세스 응답이지 DB/인증 준비 완료가 아니다.
- 초기 화면: API 연결 상태, 로그인 연동 준비 중, 자산 데이터 연결 전 표시.
- 사용자 로컬 터미널에서 .NET Release 빌드, TypeScript 검사, Vite 빌드 성공.
- Python 2개 + API 4개 + 프런트엔드 7개 = 총 13개 테스트 통과.
- API 테스트는 로컬 TRX 파일로도 확인. 전체 검증을 에이전트가 재실행한 것은 아니다.
- DB 접속, 원본 DDL 실행·수정, 스키마 변경 없음.

## 다음 세션에서 실행할 순서

1. 실제 작업 디렉터리가 새 로컬 경로인지 확인한다. AGENTS.md 및 위 문서를 읽는다.
2. 명령 실행 환경의 네트워크와 `.tools` 설치 파일 존재를 확인한다.
3. 이전 후 경로/복원/빌드/테스트를 검증한다. 오류가 나면 기존 절대 경로를 참조하는 생성 산출물 여부를 확인한다.
4. npm 취약점 상세를 확인하고 영향 범위와 수정 버전을 검토하여 조치한다.
5. 초기 화면과 실제 API 통신, 개발 서버 파일 변경 반영을 확인한다.
6. Entra 인증·인가 → DDL 기반 읽기 전용 EF 매핑 → 승인된 비운영 DB 통합 검증 → CI 순서로 진행한다.

프로젝트 루트에서:

```bash
bash scripts/verify.sh
bash -c 'source scripts/environment.sh && cd src/frontend && npm audit'
```

도구를 복사하지 않았다면 먼저 `bash scripts/bootstrap.sh`를 실행한다.
환경 설정은 각 스크립트가 수행하므로 일반 셸의 PATH에서 node/dotnet이 보이지 않아도 된다.

실행 확인은 별도 터미널 두 개에서:

```bash
bash scripts/dev.sh api
```

```bash
bash scripts/dev.sh frontend
```

화면: `http://127.0.0.1:5173` / 상태 API: `http://127.0.0.1:5080/api/health/live`.

## 미해결 사항

- npm audit moderate 2건: 대상 패키지/advisory 상세 미확인. `--force`로 일괄 변경하지 말고 상세를 먼저 확인한다.
- fsevents@2.3.3 설치 스크립트 승인 안내: 현재 빌드/테스트는 통과. 개발 서버 파일 감지는 미검증.
- 에이전트 셸은 nodejs.org 및 registry.npmjs.org DNS 조회 실패. 사용자 일반 터미널에서는 설치·복원 성공.
  새 폴더와 네트워크 권한은 별개이며 새 세션에서 실제 접근을 다시 확인해야 한다.
- 오프라인 npm audit의 0건 출력은 취약점 해소 근거가 아니다.
- Entra Tenant/SPA/API 등록 정보, scope, Redirect URI, 역할 매핑 미확정.
- SQL Server 버전·호환성 수준·collation·비운영 연결 환경·조회 전용 계정 제공 방식 미확정.
- Git 저장소 및 CI 플랫폼 미확정. 최초 확인 시 Git 저장소가 아니었음.
- MUI, TanStack Query, MSAL, EF Core는 아직 설치/구현하지 않음.

## 반드시 유지할 제약

- `database/ABCASSET_original.sql`이 스키마 사실 기준. ABCASSET.dbo의 5개 테이블 구조를 임의 변경하지 않는다.
- ASSET_USER는 소유자 마스터이며 Entra 사용자 테이블이 아니다.
- 원천 테이블 일반 CRUD 금지. 프런트엔드에서 DB 직접 접근 금지.
- 실제 업무 API 추가 전 토큰 검증·역할 인가와 접근 차단 테스트를 구현한다.
- 자동 Migrate/EnsureCreated 또는 원본 DDL 자동 실행 금지. DB 변경은 별도 제안·승인 대상.
- 동기화 프로시저/파라미터/반환 계약 및 동시성 정책 확인 전 실제 실행 비활성화.
- 비밀값은 소스·문서에 저장하지 않고 토큰·개인정보는 로그에 남기지 않는다.
- 구현별 테스트와 결과·미검증 항목을 기록한다.

## 새 세션에 전달할 문장

> RICP 프로젝트를 로컬 경로로 복사했습니다. AGENTS.md와 docs/HANDOFF.md 및 연결된 문서를 읽고 EPIC-001을 이어서 진행해줘. 먼저 현재 경로·개발 도구·네트워크 접근을 확인하고 이전 후 빌드/테스트와 npm 취약점 2건을 확인해줘. 기존 DB 스키마와 원본 DDL은 변경하지 마.
