# EPIC-001 검증 기록

## Git 준비 및 중단된 CI 초안 점검 — 2026-11-03

- GitHub 대상은 `yuseng431/AssetDashBoard`로 정해졌으며 사용자가 형상관리를 먼저 요청했다.
- Git 초기화는 에이전트 환경의 `.git` 쓰기 제한으로 실패했고, 원격 조회도 DNS 오류로 실패했다.
  저장소 연결·커밋·푸시 완료로 기록하지 않는다.
- CI 준비 중 추가한 환경 선택 테스트에서 macOS의 `/var`와 `/private/var` 별칭 차이로
  2개가 실패했다. 테스트 임시 루트를 `Path.resolve()`로 정규화한 뒤
  `python3 -m unittest discover -s tests -p 'test_*.py' -v` 총 8개가 통과했다.
- 이 실행은 Python 테스트만 재검증한 것이며 .NET/프런트엔드의 전체 재실행은 아니다.
- 원본 DDL SHA-256은 기존 기록과 동일하다. GitHub Actions 실행은 아직 수행하지 않았다.

## Vitest 보안 패치 검증 완료 — 2026-11-02 16:06

- 사용자 일반 터미널에서 Vitest를 4.1.12로 정확히 고정해 설치했다.
- 에이전트가 package.json, package-lock.json 및 실제 node_modules를 확인했다.
  Vitest와 @vitest/mocker 모두 4.1.12이며 선언·잠금·설치 버전이 일치한다.
- 사용자 제공 로그에서 패치 후 TypeScript 검사, Vitest 7개 테스트, Vite 빌드 성공을 확인했다.
- 사용자 온라인 `npm audit` 결과: **found 0 vulnerabilities**. 앞서 보고된 moderate 2건은 조치 완료다.
- 16:03 전체 검증 스크립트의 테스트 13개 통과 이후, 변경된 프런트엔드 영역을 재검증했다.
  패치 후 백엔드 테스트를 다시 실행한 것으로 기록하지 않는다.
- fsevents@2.3.3 설치 스크립트 승인 안내는 남아 있다. 이번 타입 검사·테스트·빌드를 막지 않았으며,
  개발 서버 파일 변경 감지와 브라우저/API 실통신은 아직 미검증이다.

로컬 이전 후 복원·빌드·테스트와 이번 npm 취약점 조치는 완료했다.
Entra 인증·인가, EF 매핑, 비운영 DB 검증, CI는 후속 구현 대상이며 EPIC-001 전체 완료는 아니다.
아래는 조치 전 실행 이력이며 최신 상태는 이 항목을 우선한다.

## 전체 스크립트 검증 및 취약점 확인 — 2026-11-02 16:03 (패치 전 기록)

사용자 일반 터미널에서 `bash scripts/verify.sh` 전체가 성공했다.
사용자 제공 로그에서 NuGet/npm 복원, .NET Release 빌드, TypeScript 검사,
Vite 빌드 및 Python 2개 + API 4개 + Vitest 7개 = **총 13개 테스트 통과**를 확인했다.
API 성공 TRX `_choeyuseungs-MacBook-Air_2026-11-02_16_03_00_net10.0.trx`도
에이전트가 직접 확인했다(total/executed/passed 4, failed 0).
앞선 에이전트 환경의 복원 지연·소켓 권한 오류와 사용자 환경의 성공을 구분한다.

별도 온라인 `npm audit`는 실행됐으며 **moderate 2건**을 보고했다.
대상은 `@vitest/mocker` 및 이를 사용하는 `vitest`이며 현재 Vitest는 4.1.11이다.

- [GHSA-qxg6-89mg-rqv8](https://github.com/advisories/GHSA-qxg6-89mg-rqv8): 수동 mock 등록을 통한 코드 주입.
- [GHSA-xp26-3454-mjgp](https://github.com/advisories/GHSA-xp26-3454-mjgp): Windows 경로 처리로 redirect 허용 목록 우회.
- 두 문제의 4.x 수정 버전은 4.1.12이며 [공식 릴리스](https://github.com/vitest-dev/vitest/releases/tag/v4.1.12)에서 수정 내용을 확인했다.
- 현재 Node 테스트 설정은 해당 mocker 플러그인을 직접 등록하지 않는다. 개발 의존성이라도 업데이트 및 온라인 재감사가 필요하다.

에이전트가 `npm install --save-dev --save-exact vitest@4.1.12`를 시도했으나
`registry.npmjs.org` DNS 오류로 다운로드에 실패했다. package.json과 잠금 파일은
4.1.11로 유지됐으며, 부분 설치를 정리하기 위해 기존 잠금 파일로 `npm ci --offline --no-audit`를 실행했다.
복원 후 TypeScript 검사·Vitest 7개·Vite 빌드가 다시 통과했다(4.1.11 기준).
취약점 수정 완료로 처리하지 않는다. `npm audit fix --force` 대신 아래처럼 대상 버전을 명시한다.

프로젝트 루트의 사용자 터미널에서 실행:

```bash
bash -c 'set -e
source scripts/environment.sh
cd src/frontend
npm install --save-dev --save-exact vitest@4.1.12
npm run typecheck
npm test
npm run build
npm audit
'
```

남은 항목: 패치 설치 후 테스트·빌드·온라인 감사, 개발 서버 파일 변경 감지 및
브라우저/API 실통신 확인. Entra/EF/DB/CI 구현은 별도 후속 작업이며 EPIC-001 전체 완료는 아니다.

## 로컬 이전 후 개별 재검증 — 2026-11-02 (전체 스크립트 성공 전 기록)

작업 경로: `/Users/yuseung/AI/Codex/Asset-Dashboard/Codex`.
아래는 에이전트 실행 결과와 사용자 일반 터미널에서 수행한 API 재검증 결과다.
분리 실행을 합산해 테스트 **13개 통과**를 확인했다. 기본 검증 스크립트의
전체 연속 실행과 온라인 취약점 감사는 아직 완료하지 못했다.

| 검사 | 이번 결과 |
|---|---|
| `bash scripts/verify.sh` | Python 2개 통과 후 .NET 복원 단계에서 완료되지 않아 45초 제한으로 종료(exit 124) |
| 로컬 NuGet 캐시 복원 | 4개 프로젝트 성공. 잠금 모드 유지, 이번 보조 실행에서만 온라인 감사 비활성화 |
| .NET Release 빌드 | 성공, 경고 0개·오류 0개 |
| API 테스트 | 에이전트 환경에서는 소켓 권한 오류로 중단. 사용자 일반 터미널 재실행에서 4개 통과·실패 0개·건너뜀 0개, 에이전트가 TRX 확인 |
| npm 캐시 복원 | `npm ci --offline --no-audit` 성공, 52개 패키지 설치 |
| TypeScript 검사 | 통과 |
| Vitest | 7개 통과 |
| Vite 프로덕션 빌드 | 성공 |
| Bash 구문·JSON/XML 파싱 | 통과 |
| 원본 DDL SHA-256 | 아래 이전 기록과 동일 |
| 온라인 npm 감사 | `ENOTFOUND registry.npmjs.org`로 실패. 기존 moderate 2건의 해소 여부 확인 불가 |

이번 통과 테스트는 Python 2개 + 프런트엔드 7개(에이전트 실행) + API 4개(사용자 실행) = **13개**다.
API 테스트는 같은 로컬 복사본의 빌드 결과를 `--no-build --no-restore`로 실행해 성공했다.
이 비교 결과는 앞선 중단이 테스트 코드 실패가 아니라 에이전트 실행 환경의 소켓 제한에
기인한다는 판단을 뒷받침한다. 이를 해결하기 위한 앱 코드 변경은 필요하지 않았다.
fsevents@2.3.3 설치 스크립트 승인 안내가 다시 표시됐다. 임의 승인하지 않았으며
개발 서버 파일 변경 감지·브라우저/API 실통신은 이번 검증 범위에서 확인하지 않았다.

기본 검증 스크립트, 앱 소스, 패키지 버전과 잠금 파일은 변경하지 않았다.
DB 접속이나 원본 DDL 변경·실행도 수행하지 않았다.
보조 복원에서 온라인 감사를 끈 것은 빌드 확인을 위한 것이며 취약점 검증 통과를 의미하지 않는다.

보조 백엔드 검증 명령(`source scripts/environment.sh` 후 실행):

```bash
dotnet restore RICP.slnx --locked-mode --source .cache/nuget -p:NuGetAudit=false --disable-parallel -m:1 -nr:false
dotnet build RICP.slnx --no-restore --configuration Release -m:1 -nr:false -p:UseSharedCompilation=false
dotnet test RICP.slnx --no-build --no-restore --configuration Release -m:1 -nr:false --logger trx
```

로컬 실행 로그: `.cache/verification-2026-11-02/`의 `verify.log`,
`backend.log`, `frontend.log`, `npm-audit.json`, `npm-audit.stderr`.
API 중단 기록: `tests/RICP.Api.Tests/TestResults/_choeyuseungs-MacBook-Air_2026-11-02_15_21_51_net10.0.trx`.
API 성공 기록: `tests/RICP.Api.Tests/TestResults/_choeyuseungs-MacBook-Air_2026-11-02_15_25_55_net10.0.trx`.
성공 TRX에서 `outcome="Completed"`, `total="4"`, `executed="4"`, `passed="4"`, `failed="0"` 및 각 테스트의 `Passed`를 확인했다.
로그와 TRX는 버전 관리 제외 경로에 있다.

전체 검증 완료에는 네트워크와 로컬 테스트 통신 소켓을 사용할 수 있는 환경에서
`bash scripts/verify.sh` 및 온라인 `npm audit`의 재실행이 필요하다.

## 초기 구성 검증 — 2026-10-29

## 실행 완료

| 검사 | 결과 |
|---|---|
| 설치 스크립트 단위 테스트 | 2개 통과. 체크섬 불일치 시 압축 해제 금지, 공백 포함 경로의 인자 전달 검증 |
| Bash 구문 검사 | bootstrap/environment/dev/verify 스크립트 통과 |
| JSON 파싱 | global.json, package.json, tsconfig.json, appsettings.json 통과 |
| XML 파싱 | 솔루션, 공통 props, 프로젝트 4개 통과 |
| Python 구문 검사 | 설치 스크립트 통과 |
| 원본 DDL 무결성 | 작업 전후 SHA-256 동일 |

원본 DDL SHA-256:
`1f240c25e0e62666785d767d7f94bf843e69fa094aad0cec6b435af488ee541a`

## 로컬 실행 완료 — 사용자 제공 로그 및 파일 확인

- .NET SDK 10.0.403, Node.js 24.22.2, npm 11.19.1 설치 완료.
- NuGet/npm 복원 완료. package-lock.json 및 NuGet packages.lock.json 존재 확인.
- .NET Release 빌드 성공. API 통합 테스트 4개 통과(로컬 TRX에서도 확인).
- TypeScript 검사 통과. Vitest 7개 테스트 통과. Vite 프로덕션 빌드 성공.
- 설치 스크립트 테스트 2개 포함 총 13개 테스트 통과.
- React 19.2.9, TypeScript 6.0.3, Vite 8.3.5, Vitest 4.1.11 직접 의존성 고정 확인.
- 전체 검증은 사용자 로컬 터미널에서 실행한 결과이며 에이전트가 재실행한 결과는 아님.

## 남은 검증 및 이슈

- npm audit: 사용자 로그에서 moderate 2건. 대상 패키지 및 advisory 상세 미확인.
- 에이전트의 온라인 감사는 registry.npmjs.org DNS 실패로 조회 불가.
  오프라인 감사는 advisory 조회를 보장하지 않으므로 0건 출력을 해소 근거로 사용하지 않음.
- fsevents@2.3.3 설치 스크립트 승인 안내가 있었으나 현재 빌드/테스트는 통과.
  개발 서버 파일 변경 감지는 아직 확인하지 않음. 설치 스크립트 일괄 승인하지 않음.
- 브라우저 화면 및 실제 API 통신 확인: 미실행.
- Entra 인증·인가, EF 매핑 및 DB 통합 테스트: 구현 전.
- CI 플랫폼 연동: 미완료. EPIC-001 전체 완료 아님.

## 다음 단계

사용자 로컬 터미널에서 상세 감사 결과 확인:

```bash
bash -c 'source scripts/environment.sh && cd src/frontend && npm audit'
```

대상 패키지와 수정 버전을 확인한 뒤 변경하고 관련 테스트/빌드를 재검증한다.
DB 접속 및 원본 DDL 변경/실행은 수행하지 않았다.
