/* 
	
	* DCL(Data Control Language) 
	
	- 데이터를 다루기 위한 권한을 다루는 언어(데이터 권한 제어 언어)
	- 계정에 DB, DB객체에 대한 접근을 부여(GRANT)하고, 회수(REVOKE)하는 언어
	
	
	* 권한의 종류

		1) 시스템 권한 : DB접속, 객체 생성 권한
		
		CRETAE SESSION   : 데이터베이스 접속 권한
		CREATE TABLE     : 테이블 생성 권한
		CREATE VIEW      : 뷰 생성 권한
		CREATE SEQUENCE  : 시퀀스 생성 권한
		CREATE PROCEDURE : 함수(프로시져) 생성 권한
		CREATE USER      : 사용자(계정) 생성 권한
		DROP USER        : 사용자(계정) 삭제 권한
		DROP ANY TABLE   : 임의 테이블 삭제 권한
		
		
		2) 객체 권한 : 특정 객체를 조작할 수 있는 권한
		
		  권한 종류                 설정 객체
		    SELECT              TABLE, VIEW, SEQUENCE
		    INSERT              TABLE, VIEW
		    UPDATE              TABLE, VIEW
		    DELETE              TABLE, VIEW
		    ALTER               TABLE, SEQUENCE
		    REFERENCES          TABLE
		    INDEX               TABLE
		    EXECUTE             PROCEDURE

*/


/* 계정(사용자, USER)

* 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정
                모든 권한과 책임을 가지는 계정
                ex) sys(최고관리자), system(sys에서 권한 몇개 제외된 관리자)


* 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
                작업을 수행할 수 있는 계정으로
                업무에 필요한 최소한의 권한만을 가지는 것을 원칙으로 한다.
                ex) kh_ksh계정(개인의 계정), updown, workbook 등
*/



-- 1. (sys) 사용자 계정 생성

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; 
--> 예전 SQL방식 허용(계정명 간단히 작성 가능)

-- [사용자 계정 작성법] 
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
CREATE USER ksh_sample IDENTIFIED BY sample1234;

-- 2. 새 연결(접속 방법)추가
-- 새 데이터베이스 연결에서 ORA-01045 : CREATE SESSOION 권한이 없어서 로그인 실패

-- 3. [접속 권한 부여 작성법]
-- GRANT 권한, 권한, ... TO 사용자명;
GRANT CREATE SESSION TO ksh_sample;

-- 4. 권한 부여 후 접속 성공

-- 5. (sample) 계정에서 테이블 생성
CREATE TABLE TB_TEST (
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
); 
--> ORA-01031: 권한이 불충분합니다
-- CREATE TABLE 테이블 생성 권한이 제한과
--  데이터를 저장할 수 있는 공간(TABLESPACE)을 할당 (공간을 활용할 수 있는 권한)

-- 6. (sys) 테이블 생성권한 + TABLESPACE 할당
GRANT CREATE TABLE TO KSH_SAMPLE;

ALTER USER KSH_SAMPLE DEFAULT TABLESPACE
SYSTEM QUOTA UNLIMITED ON SYSTEM;

-- 7. (sample) 계정에서 테이블 생성
CREATE TABLE TB_TEST (
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
); 

SELECT * FROM TB_TEST;


--------------------------------------------------------------------------------

-- ROLE(역할) : 권한의 묶음
--> 묶어둔 권한을 특정 계정에 부여 시 
--  부여받은 해당 계정은 부여받은 권한을 이용해 특정 ROLE을 갖게 된다.


-- (SYS) SAMPLE계정에 CONNECT, RESOURCE ROLE을 부여
GRANT CONNECT, RESOURCE TO KSH_SAMPLE;

-- CONNECT : DB 접속과 관련된 권한 ROLE
-- RESOURCE : DB 사용을 위한 기본 객체 생성 권한 ROLE

---------------------------------------------------------------------------------


-- 객체 권한 부여
-- 사용자 계정끼리 < KH_KSH / KSH_SAMPLE > 서로 객체 접근 권한 부여 

-- 1. (SAMPLE) KH_KSH 계정의 EMPLOYEE 테이블 조회
SELECT * FROM KH_KSH.EMPLOYEE;
--> ORA-00942: 테이블 또는 뷰가 존재하지 않습니다.
---> 접근 권한이 없어 조회 불가


-- 2. (KH) SAMPLE계정에 EMPLOYEE 테이블 조회 권한 부여
-- [객체끼리 권한 부여 작성법]
-- GRANT 객체권한 ON 객체명 TO 사용자명;
GRANT SELECT ON EMPLOYEE TO KSH_SAMPLE;


-- 3. (SAMPLE) 다시 KH_KSH 계정의 EMPLOYEE 테이블 조회
SELECT * FROM KH_KSH.EMPLOYEE; 
--> 조회 가능 (SELECT 권한을 부여받아서 조회 가능)


-- 4. (SAMPLE) KH_KSH.EMPLOYEE 테이블을 복사해서 생성
CREATE TABLE EMP_SAMPLE
AS SELECT * FROM KH_KSH.EMPLOYEE;

SELECT * FROM EMP_SAMPLE;
--> 복사된 테이블이라 원본 영향 X


-- 5. (KH) SAMPLE계정에 부여한 EMPLOYEE 테이블 조회 권한을 회수
-- [권한 회수 작성법]
-- REVOKE 객체권한 ON 객체명 FROM 사용자명[];
REVOKE SELECT ON EMPLOYEE FROM KSH_SAMPLE;


-- 6. (SAMPLE) 권한 회수 확인
SELECT * FROM KH_KSH.EMPLOYEE; -- 권한 회수로 인해 조회 불가
SELECT * FROM EMP_SAMPLE; -- 복사된 테이블은 조회 가능





