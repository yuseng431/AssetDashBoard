# EPIC-001 로컬 개발 환경

## 현재 범위

React/TypeScript 초기 화면, ASP.NET Core 프로세스 상태 API, Application/Infrastructure
프로젝트 경계 및 기본 테스트를 구성했다. 인증·인가, EF Core, 실제 DB 연결, CI 서비스
연결은 아직 구현하지 않았다. 업무 API는 노출하지 않으며 상태 API의 `ok`는 프로세스
응답만 뜻한다. DB/Entra/동기화 정상 여부를 의미하지 않는다.

## 도구 설치와 패키지 복원

macOS arm64/x64에서 Python 3, curl, tar가 필요하다. 프로젝트 루트에서 실행한다.

```bash
bash scripts/bootstrap.sh
bash scripts/verify.sh
```

- .NET SDK: `global.json`의 10.0.403, Node.js: `.node-version`의 24.22.2.
- 공식 HTTPS 배포처에서 다운로드하고 SHA-512(.NET), SHA-256(Node.js)를 검증한다.
- `.tools/`에 설치한다. 시스템 디렉터리, 셸 프로필, 기존 도구는 수정하지 않는다.
- 의존성 캐시는 `.cache/`에 저장한다. 두 디렉터리는 버전 관리에서 제외한다.
- 최초 npm 복원 성공 시 직접 의존성을 정확한 버전으로 변환하고 package-lock.json을 생성한다.
- NuGet 복원은 각 프로젝트의 packages.lock.json을 생성한다. 생성된 잠금 파일은 커밋한다.
- 이후 검증은 npm ci / dotnet restore --locked-mode를 사용한다.
- 사용자 로컬 터미널에서 설치·패키지 복원·잠금 파일 생성 및 검증 완료(2026-10-29).
- 2026-11-02 로컬 폴더로 이전 후 전체 검증 성공. Vitest 4.1.12 패치 후 프런트엔드 재검증과 온라인 npm 감사(취약점 0건) 완료.

## 실행

별도 터미널 두 개에서 각각 실행한다.

```bash
bash scripts/dev.sh api
```

```bash
bash scripts/dev.sh frontend
```

브라우저: http://127.0.0.1:5173
프로세스 상태: http://127.0.0.1:5080/api/health/live

개발 서버는 로컬 루프백에만 바인딩하며 Vite가 /api 요청을 API로 전달한다.
배포용 HTTPS 및 Entra 설정은 후속 단계에서 구성한다. 현재 상태로 외부 배포하지 않는다.
MUI, TanStack Query, MSAL, EF Core는 각 기능 착수 시 호환 버전을 확인하여 추가한다.

## 다음 구현 순서

1. 기본 설치/복원/빌드/테스트 및 npm moderate 2건 조치 완료. 초기 화면/API 실통신과 개발 서버 파일 변경 감지 확인은 남아 있음.
2. Entra 앱 등록 및 역할 계약 확인, 토큰 검증과 기본 접근 차단, 401/403 테스트.
3. ABCASSET DDL 그대로 5개 엔터티 매핑, 읽기 전용 연결 및 NULL/타입 검증.
4. 승인된 비운영 DB를 사용한 통합 검증.
5. Git 저장소 및 CI 플랫폼 확정 후 scripts/verify.sh를 CI에 연결.

원본 DDL을 실행하거나 수정하는 단계는 없다. DB 스키마 변경은 별도 승인 대상이다.
