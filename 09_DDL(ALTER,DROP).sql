-- DDL(Data Definition Language)
-- 객체를 생성(CREATE), 수정(ALTER), 삭제(DROP)하는 데이터 정의 언어

/*
 
   ALTER(바꾸다, 수정하다)
 
   테이블에서 수정가능한 요소
	1) 제약조건(추가/삭제)
	2) 컬럼(추가/수정/삭제)
	3) 이름 변경(테이블명, 제약조건명, 컬럼명)                    

*/


--------------------------------------------------------------------------------------

-- 1. 제약조건의 추가/삭제
----> 제약조건은 수정이 불가하므로 삭제 후 추가하는 방법으로 수정 가능


-- 1-1) 추가
-- ALTER TABLE 테이블명
-- ADD [CONSTRAINT 제약조건명] 제약조건(지정컬럼명)
-- [REFERENCES 테이블명[(컬럼명)]; <- FK인 경우

-- 1-2) 삭제
-- ALTER TABLE 테이블명
-- DROP CONSTRAINT 제약조건명;


-- DEPARTMENT 테이블 복사 (컬럼명, 데이터타입, 값, 제약조건NOT NULL 복사)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

--  DEPT_COPY의 DEPT_TITLE컬럼에 UNIQUE 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_TITLE_U UNIQUE(DEPT_TITLE); 

--  DEPT_COPY의 DEPT_TITLE컬럼에 UNIQUE 제약조건 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_TITLE_U;



-- *** DEPT_COPY의 DEPT_TITLE컬럼에 NOT NULL 제약조건 추가/삭제 ***
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_TITLE_NN NOT NULL(DEPT_TITLE);
--> ORA-00904: : 부적합한 식별자
-- NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌
-- 컬럼 자체에 NULL을 허용/비허용을 제어하는 성질 변경의 형태로 인식


-- MODIFY 구문을 사용하여 NULL 제어
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL; -- DEPT_TITLE로 수정

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NULL;


--------------------------------------------------------------------------------------



-- 2. 컬럼(추가/수정/삭제)

-- 2-1) 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30));

-- LNAME 컬럼 추가 (DEFAULT값 지정)
ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국');
--> 컬럼이 생성되면서 기본값이 자동 삽입




-- 2-2) 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; -> 데이터 타입 변경

-- D10, 개발1팀 추가
INSERT INTO DEPT_COPY VALUES ('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
-- 오류 발생! "KH_KSH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2) 

ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR(3); 
-- 컬럼 데이터타입 수정 후 위의 INSERT구문 다시 추가하면 OK



-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; -> 기본값 변경

-- LNAME의 기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
--> 기본값을 변경하더라도 기존의 데이터는 그대로 유지

UPDATE DEPT_COPY SET LNAME = DEFAULT WHERE LNAME='한국'; 
COMMIT; -- 컬럼값 수정







-- ALTER TABLE 테이블명 MODIFY 컬럼명 NULL/NOT NULL; -> NULL여부 변경

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP(삭제할컬럼명); 
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명; 

-- 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(CNAME);
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY DROP(LOCATION_ID);
ALTER TABLE DEPT_COPY DROP(DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP(DEPT_ID);
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다


-- ** 컬럼 삭제시 주의사항! **
-- 테이블이란 행과 열로 이루어진 데이터베이스의 가장 기본적인 객체로 테이블에 데이터가 저장
-- 테이블은 최소 1개 이상의 컬럼이 존재해야하므로 모든 컬럼을 삭제하는 것은 불가능!!




-- 테이블 완전 삭제
DROP TABLE DEPT_COPY;


-- DEPARTMENT 테이블 복사해서 DEPT_COPY 새로 생성
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NOT NULL 제약조건만 복사

-- DEPT_COPY 테이블의 DEPT_ID컬럼에 PK 추가(제약조건명은 D_COPY_PK )
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY (DEPT_ID); 




--------------------------------------------------------------------------------------

-- 3. 컬럼. 제약조건, 테이블 등의 이름 변경

-- 3-1) 컬럼명변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3-2) 제약조건 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

-- 3-3) 테이블명 변경
ALTER TABLE DEPT_COPY RENAME TO DCOPY;
SELECT * FROM DCOPY;


--------------------------------------------------------------------------------------


-- 4. 테이블 삭제
-- DROP TABLE 테이블명 [CASCADE CONSTRAINT];

-- 4-1) 관계가 형성되지 않은 테이블 (DCOPY) 삭제
DROP TABLE DCOTY;


-- 4-2) 관계가 형성된 테이블 삭제
-- TB1테이블 생성
CREATE TABLE TB1 (
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER 
);

SELECT * FROM TB1;

-- TB1과 관계가 형성된 TB2생성
CREATE TABLE TB2 (
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1 
);

-- TB1에 샘플데이터 삽입
INSERT INTO TB1 VALUES(1, 100);
INSERT INTO TB1 VALUES(2, 200);
INSERT INTO TB1 VALUES(3, 300);
COMMIT;


-- TB2에 샘플데이터 삽입
INSERT INTO TB2 VALUES(11, 1);
INSERT INTO TB2 VALUES(12, 2);
INSERT INTO TB2 VALUES(13, 3);
INSERT INTO TB2 VALUES(14, NULL);

INSERT INTO TB2 VALUES(15, 4); 
--ORA-02291: 무결성 제약조건(KH_KSH.SYS_C008443)이 위배되었습니다- 부모 키가 없습니다

SELECT * FROM TB2;
COMMIT;


-- TB1삭제
DROP TABLE TB1;
-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-- 해결1) 자식, 부모 테이블 순서로 삭제(단, 자식테이블도 삭제됨)
-- 해결2) ALTER를 통해 FK제약조건 삭제 후 TB1삭제
-- 해결3) DROP TABLE의 삭제옵션 CASCADE CONSTRAINT 사용(2번 방법의 번거로움 해결)
		  --> 삭제하려는 테이블과 연결된 FK제약조건을 모두 삭제
DROP TABLE TB1 CASCADE CONSTRAINT;


--------------------------------------------------------------------------------------

/* DDL의 주의사항 *
 
 - CREATE, ALTER, DROP은 COMMIT/ROLLBACK 불가
 
 - DDL과 DML 구문을 섞어서 수행하면 안된다!
   DDL은 수행시 존재하고 있는 트랜잭션이 전부 강제 COMMIT되기 때문에
   DDL이 종료된 후 DML구문을 수행할 수 있도록 권장   */

-- 컬럼에 데이터 삽입(DML)
SELECT * FROM TB2;
INSERT INTO TB2 VALUES (15,5);
INSERT INTO TB2 VALUES (16,6);
ROLLBACK; -- INSERT(DML) ROLLBACK 가능


-- 컬럼명 변경(DDL)
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;
ROLLBACK; -- ALTER(DDL)  ROLLBACK 불가능
