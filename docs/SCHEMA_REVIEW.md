# ABCASSET SQL Server DDL 최종 정적 검토

대상: `database/ABCASSET_original.sql` (2026-10-29 제공본). SQL Server 인스턴스 실행 검증은 수행하지 않음.

## 확인된 구조
- 테이블 5개: `STORE`, `ASSET_CATEGORY`, `ASSET_ITEM`, `ASSET_USER`, `ASSET`.
- PK 5개, FK 5개: 카테고리 자기참조, 사용자→매장, 자산→사용자/카테고리/아이템.
- 카테고리 단일 FK 적용, 자기 자신을 부모로 지정하는 CHECK 존재.
- `sp_addextendedproperty`의 컬럼 대상 테이블/컬럼 명칭은 정적 점검상 일치.
- `USE ABCASSET` 이후 `GO` 추가 권장(필수 구문 오류는 아님).

## 주의·결정 사항
1. `ASSET_CATEGORY_LEVEL` 설명은 현재 '사용구분'으로 작성됨. 실제 의미가 계층 수준이라면 설명 변경 권장.
2. `ASSET_USER.USE_YN` 설명도 '사용구분'임. Y/N 활성 여부인지 원천 코드 확인.
3. `STORE.DIR_JOIN_FLAG` 및 `DIRECT_TYPE`의 설명과 실제 의미 검증 필요.
4. `STORE.X_POINT/Y_POINT numeric(10,5)`의 좌표계 및 위도/경도 순서 확인.
5. `ASSET_CATEGORY` 자기참조 CHECK는 A→B→A 간접 순환을 막지 못함. 데이터 수집/관리 시 검증.
6. `ASSET.ASSET_CATEGORY_CD`, `ASSET.ASSET_USER`는 NULL 허용. UI에서 미분류·미할당을 지원.
7. `ASSET_USER.STORE_CD`는 NULL 허용. 본사 직원과 매장 계정 매핑 규칙 확정 필요.
8. `ASSET_ITEM`은 이름만 존재하며 모델·제조사·EOS 필드는 없음. UI에서 임의의 모델 정보 생성 금지.
9. FK 인덱스는 자동 생성되지 않음. 조회 패턴에 맞춰 별도 검토.
10. `CREATE TABLE`은 기존 테이블이 있는 DB에서 재실행 불가. 별도 테스트 DB에서 검증.
11. 데이터 동기화 저장 프로시저는 첨부 DDL에 정의되어 있지 않음. 이름/실행 권한/파라미터/출력/실패 복구를 확인해야 함.
12. 문자 컬럼은 `varchar` 기반. 한글 원천 데이터의 DB collation/코드페이지를 검증하고 필요시 별도 승인하에 `nvarchar` 변경 검토.

## 검증 SQL 예시
```sql
USE ABCASSET;
GO
SELECT name FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo');
SELECT fk.name, OBJECT_NAME(fk.parent_object_id) AS ChildTable,
       OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys AS fk;
SELECT name FROM sys.procedures WHERE schema_id = SCHEMA_ID('dbo');
```

## 출시 전 필수 게이트
- [ ] 비운영 DB에서 전체 DDL 실행 성공
- [ ] 5개 FK 실제 생성 확인
- [ ] 원천 마스터의 코드값/매핑 규칙 확인
- [ ] 동기화 프로시저 계약·실행 권한·중복 실행 정책 확정
- [ ] 동기화 실패 시 기존 조회 데이터 보존 검증
