/* SEQUENCE(순서, 연속, 수열)
 
 - 순차적 번호 자동 발생 역할을 하는 객체
 
 - SEQUENCE 객체를 생성하여 호출하게 되면 
   지정된 범위 내에서 일정한 간격으로 증가하는 숫자가 순차적으로 출력
   
   EX) 1부터 10까지 1씩 증가하고 반복하는 시퀀스 객체
      1 2 3 4 5 6 7 8 9 10 1 2 3 4 5 6 7 8 9 10 1 2 3 ...
   
  ** SEQUENCE는 주로 PK역할의 컬럼에 삽입되는 값을 만드는 용도로 사용
   	 -> 인위적 주식별자
  
   
 [SEQUENCE 작성법]
	  CREATE SEQUENCE 시퀀스이름
	  [STRAT WITH 숫자]   -> 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
	  [INCREMENT BY 숫자] -> 다음 값에 대한 증가치, 생략하면 자동 1이 기본
	  [MAXVALUE 숫자 | NOMAXVALUE] -> 발생시킬 최대값 지정 (10의 27승 -1) - 범위 설정
	  [MINVALUE 숫자 | NOMINVALUE] -> 최소값 지정 (-10의 26승)
	  [CYCLE | NOCYCLE]   -> 값 순환 여부 지정, 기본값이 NOCYCLE
	  [CACHE 바이트크기 | NOCACHE] -> 캐쉬메모리 기본값이 20바이트!!! 최소값은 2바이트


    - 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	  -> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상


    ** 시퀀스 사용 방법 **
    
    1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴. (INCREMENT BY만큼 증가된 값)
                          단, 시퀀스 생성 후 첫 호출인 경우 START WITH의 값을 얻어옴.
    
    2) 시퀀스명.CURRVAL : 현재 시퀀스 번호 얻어옴.
                          단, 시퀀스 생성 후 NEXTVAL 호출 없이 CURRVAL를 호출하면 오류 발생. 	 	 
   	  	  	 
 */
 
-- 옵션없이도 시퀀스 생성 가능
-- 범위 : 1 ~ 10^38 / 시작 : 1 / NOCYCLE / 캐시메모리 : 20BYTE
CREATE SEQUENCE SEQ_TEST;

SELECT SEQ_TEST.CURRVAL FROM DUAL;
--> 생성 후 바로 현재 값 확인은 불가능
-- ORA-08002: 시퀀스 SEQ_TEST.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
-- ** CURRVAL 주의사항 **
-- CURRVAL는 마지막 NEXTVAL 호출 값을 다시 보여주는 기능으로
-- NEXTVAL을 먼저 호출해야 CURRVAL 값 호출이 가능

SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 1

SELECT SEQ_TEST.CURRVAL FROM DUAL; -- 1

SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 2
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 3
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 4
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 5
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 6
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 7

SELECT SEQ_TEST.CURRVAL FROM DUAL; -- 7

----------------------------------------------------------------------------

-- SEQUENCE 사용 예시

CREATE TABLE EMP_TEMP
AS SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

SELECT * FROM EMP_TEMP;

-- 223번부터 10씩 증가하는 시퀀스 생성
CREATE SEQUENCE SEQ_TEMP
START WITH 223
INCREMENT BY 10
NOCYCLE -- NOCYCLE 생략 가능
NOCACHE; -- CACHE는 작성 기본 20BYTE

-- EMP_TEMP 테이블에 사원 정보 삽입
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '홍길동'); -- 223
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '고길동'); -- 233
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '이길동'); -- 243

SELECT * FROM EMP_TEMP ORDER BY 1 DESC;

----------------------------------------------------------------------------

/* SEQUENCE 수정 작성법
        
      ALTER SEQUENCE 시퀀스이름
	  [INCREMENT BY 숫자] -> 다음 값에 대한 증가치, 생략하면 자동 1이 기본
	  [MAXVALUE 숫자 | NOMAXVALUE] -> 발생시킬 최대값 지정 (10의 27승 -1) - 범위 설정
	  [MINVALUE 숫자 | NOMINVALUE] -> 최소값 지정 (-10의 26승)
	  [CYCLE | NOCYCLE]   -> 값 순환 여부 지정, 기본값이 NOCYCLE
	  [CACHE 바이트크기 | NOCACHE] -> 캐쉬메모리 기본값이 20바이트!!! 최소값은 2바이트 
	  
	   -> 시작값은 변경불가!!!!!!!

*/

-- SEQ_TEMP 를 1씩 증가하는 형태로 변경
ALTER SEQUENCE SEQ_TEMP
INCREMENT BY 1;

INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '김길동'); 
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '박길동'); 
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '최길동'); 

SELECT * FROM EMP_TEMP ORDER BY 1 DESC;


----------------------------------------------------------------------------

-- 테이블, 뷰, 시퀀스 삭제

DROP TABLE EMP_TEMP;
DROP VIEW V_DCOPY2;
DROP SEQUENCE SEQ_TEMP;










