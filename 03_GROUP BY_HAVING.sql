/* SELECT문 해석 순서

  5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
  1 : FROM 참조할 테이블명
  2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
  3 : GROUP BY 그룹을 묶을 컬럼명
  4 : HAVING 그룹함수식 비교연산자 비교값
  6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST | LAST];    */

-------------------------------------------------------------------------------------------------------------------

/* GROUP BY절 
  
 - 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 '하나의 그룹'으로 묶음
 - GROUP BY 컬럼명 | 함수식, ....

 - 여러개의 값을 묶어서 하나로 처리할 목적으로 사용
 - 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용

 - 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러 개일 경우 오류 발생
 - 여러 개의 결과 값을 산출하기 위해 그룹 함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용 */


-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서코드 조회 -- 23행
SELECT DEPT_CODE FROM EMPLOYEE;
-- 2) 전체 급여 합 -- 1행
SELECT SUM(SALARY) FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY) 
FROM EMPLOYEE
GROUP BY DEPT_CODE; --> DEPT_CODE가 같은 행끼리 하나의 그룹화하여 급여 합 조회 가능


-- EMPLOYEE 테이블에서 직급 코드가 같은 사람의 직급 코드, 급여 평균, 인원 수를 직급코드 오름차순으로 조회
SELECT JOB_CODE, ROUND(AVG(SALARY)) "급여 평균", COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


-- EMPLOYEE 테이블에서 성별과 각 성별 인원 수, 급여 합을 조회
-- (단, 인원수 오름차순)
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, COUNT(*) "인원 수", SUM(SALARY)
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') -- ** GROUP BY절에는 별칭 사용 불가 **
ORDER BY 2;


-----------------------------------------------------------------------------------------------------------------------------------------


/* WHERE절 GROUP BY절을 혼합 사용
  -> WHERE절은 각 컬럼 값에 대한 조건 
  
  < SELECT문 해석 순서 >
  
  5. SELECT
  1. FROM
  2. WHERE
  3. GROUP BY
  4. HAVING
  6. ORDER BY
  
 */

-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 부서의 평균 급여, 인원 수 조회

SELECT ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5', 'D6')
GROUP BY DEPT_CODE;


-- EMPLOYEE 테이블에서 직급별 2000년도 이후 입사자들의 급여 합
-- 단, 직급코드는 오름차순

SELECT JOB_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
WHERE HIRE_DATE >= '2000-01-01'  --> 속도가 조금 느림
--    HIRE_DATE >= TO_DATE('2000-01-01')  
--    EXTRACT (YEAR FROM HIRE_DATE) >= 2000  --> 가장 베스트
GROUP BY JOB_CODE
ORDER BY 1;


-----------------------------------------------------------------------------------------------------------------------------------------


/* 여러 컬럼을 묶어서 그룹으로 지정 가능
   --> 그룹 내 그룹 가능 (분류 세분화)

 * GROUP BY 사용시 주의사항
 -  SELECT문에 GROUP BY절을 사용할 경우
 	SELECT절에 명시된 조회하려는 컬럼 중 그룹함수가 적용되지 않은 컬럼을 모두 GROUP BY절에 작성! */



-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 수를 조회
-- 단, 부서코드 오름차순, 직급코드 내림차순

SELECT DEPT_CODE, JOB_CODE, COUNT(*) 
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE  -- DEPT_CODE 그룹을 나누고, 나눠진 그룹 내에서 JOB_CODE 다시 그룹 분류
ORDER BY 1, 2 DESC;


--------------------------------------------------------------------------------------------------------------------------


/* HAVING 절 
 - 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
 
 - HAVING 컬럼명 | 함수식 비교연산자 비교값 */



-- 부서별 평균 급여가 3백만원 이상인 부서를 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
-- WHERE SALARY >=30000000 --> 한사람의 급여가 300만 이상이라는 조건(요구충족X)
GROUP BY DEPT_CODE 
HAVING AVG(SALARY) >=3000000
ORDER BY DEPT_CODE;


-- 직급별 인원수가 5명 이하인 직급코드, 인원 수 조회
-- 직급코드는 오름차순
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE 
GROUP BY JOB_CODE 
HAVING COUNT(*) <= 5  -- ** HAVING 절에는 그룹함수가 반드시 작성 **
ORDER BY 1; 




--------------------------------------------------------------------------------

/* 집계함수(ROLLUP, CUBE)
 
 - 그룹별 산출 결과 값의 집계를 계산하는 함수
   (그룹별로 중간 집계 결과를 추가)
   
 - GROUP BY절에서만 함께 사용 */



/* ROLLUP
 GROUP BY 절에서 가장 먼저 작성된 컬럼의 중간 집계를 처리 */

SELECT DEPT_CODE , JOB_CODE , COUNT(*) 
FROM EMPLOYEE
GROUP BY ROLLUP (DEPT_CODE , JOB_CODE)
ORDER BY 1;



/* CUBE
 GROUP BY 절에 작성된 모든 컬럼의 중간 집계를 처리 */

SELECT DEPT_CODE , JOB_CODE , COUNT(*) 
FROM EMPLOYEE
GROUP BY CUBE (DEPT_CODE , JOB_CODE)
ORDER BY 1;



--------------------------------------------------------------------------

/* SET OPERATOR(집합 연산자)

- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자
 
- UNION(합집합) : 두 SELECT구문의 결과가 중복되는 부분(공통)만 결과로 추출
  
- INTERSECT(교집합) : 두 SELECT구문의 결과를 '중복 제거'하고 하나로 합침

- UNION ALL : 두 SELECT구문의 결과를 '중복 포함'하여 하나로 합침 
			  UNION + INTERSECT
 
- MINUS(차집합) : A에서 A, B 교집합 부분을 제거하고 조회  

!!주의사항!! 
집합 연산자를 사용하기 위한 SELECT문들의 조회하는 컬럼의 타입, 개수가 모두 동일해야한다!

*/


-- 부서코드가 D5인 사원의 사번, 이름, 부서코드, 급여
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5';

-- 급여가 300만 초과인 사원의 사번, 이름, 부서코드, 급여
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;



-- UNION (중복 제거 합집합) 12행
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'
UNION 
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL (중복 포함 합집합) 14행
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'
UNION ALL 
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- INTERSECT 2행
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'
INTERSECT 
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- MINUS 4행
-- 두 SELECT 구의 중복된 데이터를 빼고, 앞의 데이터만 추출
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- 합집합의 활용 
-- 서로 다른 테이블이지만 컬럼의 타입, 개수만 일치하면 집합 연산자 사용가능
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE
UNION
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;