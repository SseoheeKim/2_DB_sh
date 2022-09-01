-- 한 줄 주석

/*
 * 범위 주석
 */

-- SQL 수행 : CTRL + ENTER
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 실습용 사용자 계정 생성
CREATE USER kh_ksh IDENTIFIED BY kh1234;

-- 사용자 계정 권한 부여
GRANT RESOURCE, CONNECT TO kh_ksh;

-- 객체 생성(테이블 등) 공간 할당량 지정
ALTER USER kh_ksh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;

