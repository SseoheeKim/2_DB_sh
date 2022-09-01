SELECT EMP_NAME FROM EMPLOYEE;

/* SELECT (DQL 또는 DML) : 데이터 조회
 *  * - 데이터를 조회하면 조건에 맞는 행들 조회 가능
 * 
 * - 조회된 행들의 집합은 "RESULT SET"(조회 결과의 집합)
 * - "RESULT SET"은 0개 이상의 행 포함
 * - 왜 0개? 조건에 맞는 행이 없을 수도 있기 때문에 
 */

-- [ 기본 작성법 ]
-- SELECT 컬럼명 FROM 테이블명;
--> 어떤 테이블의 특정 컬럼을 조회


SELECT * FROM EMPLOYEE;
-- '*' : ALL. 전부를 뜻하는 기호

SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

------------------------------------------------------------------------

-- [ 컬럼 값 산술 연산 ]
-- 컬럼 값 : 테이블 내 한 칸(== 한 셀)의 값(데이터)

-- EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여, 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12
FROM EMPLOYEE;

SELECT EMP_NAME + 10
FROM EMPLOYEE;
-- SQL Error [1722] [42000]: ORA-01722: 수치가 부적합합니다
-- 산술연산은 숫자 타입만 가능(NUMBER)

-----------------------------------------------------------------------

-- 날짜(DATE) 타입 조회
-- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회
SELECT EMP_NAME, HIRE_DATE, SYSDATE
FROM EMPLOYEE;
-- 날짜 타입의 기본 형식 1990-02-06 00:00:00.000
-- SYSDATE : 시스템 상 현재 시간(날짜)내는 상수


-- 현재 시간 조회하기
SELECT SYSDATE FROM DUAL
-- DUAL(DUmmy tAbLe) 테이블 : 가짜 테이블(임시 조회용)


--어제, 오늘, 내일 날짜 조회
SELECT SYSDATE -1, SYSDATE, SYSDATE +1
FROM DUAL;
-- 날짜에 산술연산(+,-)하면 '일(DAY) 단위'로 계산 진행


-------------------------------------------------------------


-- [ 컬럼 별칭 지정 ]

/* SELECT 조회 결과의 집합인 RESULT SET에 출력되는 컬럼명 지정
 * 
 * 
 * - 컬럼명 AS 별칭 : 띄어쓰기 / 특수문자 불가능, ONLY 문자만 OK!
 * 
 * - 컬럼명 AS "별칭" : 띄어쓰기 / 특수문자 / 문자 전부 OK!
 *  
 *** AS 생략가능 *** 
 */ 

SELECT SYSDATE -1 "하루 전", SYSDATE AS 현재시간, SYSDATE + 1 내일
FROM DUAL;


-------------------------------------------------------------

-- [ 리터럴 ] 
-- JAVA 리터럴 : 값 자체

--  DB 리터럴 : 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용
-->	DB 리터럴 표기법은 '싱글 쿼테이션'(홑따옴표)

--> " "더블 쿼테이션은 특수문자, 대소문자, 기호 등을 구분할 때 사용하는 표기법
-- 더블 쿼테이션 내에 작성되는 것들이 하나임을 의미(단위 용도)

SELECT EMP_NAME, SALARY, '원 입니다.'
FROM EMPLOYEE;


--------------------------------------------------------------

-- [ 중복 제거 ]
-- DISTINCT : 조회 시 컬럼에 포함된 중복 값은 한번만 표기
-- 주의사항 1) DISTINCT 구문은 SELECT마다 딱 한번만 작성 가능
--			2) SELECT 조회할 때 제일 앞 컬럼에 작성!	
 SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;
 

--------------------------------------------------------------

-- 3. SELECT절 : SELECT 컬럼명
-- 1. FROM절	: FROM 테이블명
-- 2. WHERE절	: WHERE 컬럼명 연산자 값;  ==> 조건절
-- 해석과정 FROM -> WHERE -> SELECT 

-- EX1) EMPLOYEE테이블에서 급여가 3백만원 초과인 사원의 사번, 이름, 급여, 부서코드 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- EX2) EMPLOYEE테이블에서 부서코드가 'D9'인 사원의 사번, 이름, 부서코드, 직급코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';
-- DB에서 비교연산자 (=) / 대입연산자 (:=)

-- 비교연산자 : >, >=, <, <=, =(같다), !=, <>(같지않다)

--------------------------------------------------------------


-- 논리연산자 AND, OR 
-- EMPLOYEE테이블에서 '급여가 300만 미만 또는 500만 이상'인 사원의 사번, 이름, 급여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE 
WHERE SALARY < 3000000 OR SALARY >= 5000000;

-- EMPLOYEE테이블에서 '급여가 300만 이상 또는 500만 미만'인 사원의 사번, 이름, 급여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE 
WHERE SALARY >= 3000000 OR SALARY < 5000000;


----------------------------------------------------------------

-- BETWEEN A AND B : A이상 B이하
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3000000 AND 6000000;


-- NOT BETWEEN A AND B : A이상 B이하가 아닌 경우 -> A미만 B초과
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3000000 AND 6000000;

----------------------------------------------------------------

-- 날짜(DATE)에 BETWEEN 이용

-- EMPLOYEE테이블에서 입사일이 1990-01-01 ~ 1999-12-31 사이인 직원의 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE 
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31';

-- 오라클은 데이터타입이 달라도 형태가 일치하면 자동으로 타입을 변환
-- EX) 1 == '1'
SELECT '같음'
FROM DUAL
WHERE 1 = '1';


-----------------------------------------------------------------

-- LIKE 
-- 찾으려는 조건의 값이 특정 패턴을 만족시키면 조회하는 연산자

-- [ LIKE 작성법 ]
-- WHERE 컬럼명 LIKE '패턴이 적용된 값'

-- [ 와일드카드 - LIKE의 패턴을 나타내는 문자 ]
-- % : 포함
-- _ : 글자 수

-- '%' 예시 
-- 'A%' : A로 시작하는 문자열
-- '%A'	: A로 끝나는 문자열
-- '%A%' : A를 포함하는 문자열

-- '_' 예시
-- 'A_' : A로 시작하는 두 글자 문자열
-- '___A' : A로 끝나는 네 글자 문자열
-- '__A__' : 세번째 문자가 A인 다섯글자 문자열
-- '_____' : 다섯글자

-- EX) EMPLOYEE테이블에서 성이 '전'씨인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';
-- WHERE EMP_NAME LIKE '전__';

-- EX) EMPLOYEE테이블에서 전화번호가 010으로 시작하는 사원의 사번, 이름, 전화번호 조회[LIKE]
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '010%';
--WHERE PHONE LIKE '010________';


-- EX) EMPLOYEE테이블에서 전화번호가 010이 아닌!! 사원의 사번, 이름, 전화번호 조회 [NOT LIKE]
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';


-----------------------------------------------------------------

-- EMAIL 컬럼에서 _앞에 글자가 세글자 인 사원 조회
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
--WHERE EMAIL LIKE '____%'; --> 4글자 이상의 문자열
-- 문제점) _를 기준점으로 삼았으나 와일드카드_와 동일한 표기로 구분 불가능
-- 해결 방법) LIKE의 ESCAPE OPTION을 이용하여 _ 를 구분한다


-- LIKE의 ESCAPE OPTION : 일반 문자로 처리할 '_'나 '%' 앞에 
--						아무 특수기호(#, $, ^ 등)를 첨부해서 구분하게 함

SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%' ESCAPE '#';
--> # 뒤에 작성된 와일드카드는 일반 문자로 탈출

/* 연습문제
 * EMPLOYEE테이블에서 이메일 '_'앞이 4글자이면서 
 * 부서코드가 'D9' OR 'D6'이고 
 * 입사일이 1990-01-01 ~ 2000-12-31
 * 급여가 270만 이상인 사원의
 * 사번, 이름, 이메일, 부서코드, 입사일, 급여 조회
 * 
 * HINT! 연산자 우선순위 : AND 가 OR 보다 우선순위가 높다.
 * 		 최우선연산자 괄호() 사용가능
 */

SELECT EMP_ID 사번, EMP_NAME 이름, EMAIL 이메일, DEPT_CODE 부서코드, HIRE_DATE 입사일, SALARY 급여
FROM EMPLOYEE
WHERE EMAIL LIKE '____#_%' ESCAPE '#' 
	AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6')
	AND HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-31'
	AND SALARY >= 2700000;
	


/* [ 연산자 우선순위]

 1. 산술연산자
 2. 연결연산자
 3. 비교연산자
 4. IS NULL / IS NOT NULL, LIKE, IN / NOT IN
 5. BETWEEN AND / NOT BETWEEN AND
 6. NOT(논리연산자)
 7. AND(논리연산자)
 8. OR(논리연산자)

*/

---------------------------------------------------------------

/* IN 연산자
 
 - 비교하려는 값과 목록에 작성된 값 중 일치하는 것이 있으면 조회하는 연산자
 
 [ IN 작성법 ]
 WHERE 컬럼명 IN(값1, 값2, 값3 ..... )
 
 (위와 같은 구문)
 WHERE 컬럼명 = 값1 OR 컬럼명 = 값2 OR 컬럼명 = 값3 ...  */
--[IN]
-- EMPLOYEE테이블에서 부서코드가 D1, D6, D9인 사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN('D1', 'D6', 'D9');
/*WHERE DEPT_CODE = 'D1'
 	 OR DEPT_CODE = 'D6'
 	 OR DEPT_CODE = 'D9'
 */


-- [NOT IN]
-- EMPLOYEE테이블에서 부서코드가 D1, D6, D9이 아닌!! 사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN('D1', 'D6', 'D9')
OR DEPT_CODE IS NULL; -- 부서코드가 NULL(없는) 


-----------------------------------------------------------------------------

/* NULL 처리연산자

 JAVA NULL : 참조하는 객체가 없음 
 DB	  NULL : 컬럼값이 없음
 
 1) IS NULL : NULL인 경우 조회
 2) IS NOT NULL : NULL이 아닌 경우 조회
 
 */


-- EMPLOYEE 테이블에서 보너스가 '있는' 사원의 이름, 보너스 조회
SELECT EMP_NAME, BONUS
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL;

-- EMPLOYEE 테이블에서 보너스가 '없는' 사원의 이름, 보너스 조회
SELECT EMP_NAME, BONUS
FROM EMPLOYEE 
WHERE BONUS IS NULL;


-----------------------------------------------------------------------------


/* ORDER BY절
 
 - SELECT문의 조회 결과인 RESULT SET을 '정렬'할 때 사용
 
 ** SELECT문 해석 시 가장 마지막에 해석된다!!!
 FROM -> WHERE ->  SELECT -> ORDER BY 순으로 해석
 
 
 [작성법]
 ORDER BY 컬럼명 [별칭] 컬럼순서 [ASC | DESC] [NULLS FIRST | NULLS LAST]
 - 컬럼명은 컬럼의 순서인 숫자로도 사용 가능
 - ORDER BY절에 컬럼명의 별칭 사용 가능
 
 */

-- EMPLOYEE 테이블 급여 오름차순으로 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY/*ASC*/;
-- 오름차순은 생략가능


-- 급여가 200만 이상인 사원의 사번, 이름, 급여 조회(단, 급여 내림차순)
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 2000000
ORDER BY SALARY DESC;


-- 입사일 순서대로 이름, 입사일 조회(별칭 사용)
SELECT EMP_NAME 이름, HIRE_DATE 입사일
FROM EMPLOYEE
ORDER BY 입사일;
-- ORDER BY절보다 SELECT절이 먼저 해석되기 때문에 별칭으로 지정도 가능




/* 정렬 중첩 : 대분류 후 소분류 정렬 
  				, 콤마 사용 (AND아님) */

-- 부서코드 오름차순 정렬 후 급여 내림차순 정렬
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE, SALARY DESC;































