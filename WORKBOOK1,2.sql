-- [ SELECT_BASIC ]

-- 1. 춘 기술대학교의 학과 이름과 계열을 조회
--   (단, 출력헤더는 "학과 명", "계열" )

SELECT DEPARTMENT_NAME "학과 명", CATEGORY "계열"
FROM TB_DEPARTMENT;

-- 2. 학과의 학과 정원을 출력
SELECT DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다.' "학과 별 정원"   
FROM TB_DEPARTMENT;


-- 3. "국어국문학과" 여학생 중 현재 휴학중인 여학생을 조회
SELECT STUDENT_NAME 
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과'
AND SUBSTR(STUDENT_SSN, 8, 1) ='2'  
AND ABSENCE_YN = 'Y';

-- 4. 도서관에서 대출 도서 장기 연체자 조회
SELECT DISTINCT STUDENT_NAME 
FROM TB_STUDENT 
WHERE STUDENT_NO IN ('A513079', 'A513090','A513091', 'A513110', 'A513119');

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열 출력
SELECT DEPARTMENT_NAME 학과이름, CATEGORY 계열
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속학과가 있다.
-- 	  춘 기술대학교의 총장 이름을 알아내라

SELECT PROFESSOR_NAME 
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. 혹시 전산상 착오로 학과가 지정되어있지 않는 학생이 있는지 확인
SELECT STUDENT_NAME 
FROM TB_STUDENT 
WHERE DEPARTMENT_NO IS NULL;

-- 8. 선수과목이 존재하는 과목은 어떤 과목인지 과목번호를 조회
SELECT CLASS_NO 
FROM TB_CLASS 
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. 춘 대학에는 어떤 계열이 있는지 조회
SELECT DISTINCT CATEGORY 
FROM TB_DEPARTMENT;

-- [ SELECT_FUNCTION]

-- 1. 영문과(코드002)학생들의 학번과 이름, 입학년도 빠른 순으로 조회

SELECT STUDENT_NO 학번, STUDENT_NAME 이름, TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') 입학년도
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE;


-- 2. 이름이 세글자가 아닌 교수의 이름과 주민번호를 조회
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_PROFESSOR 
WHERE PROFESSOR_NAME NOT LIKE '___';


-- **3. 나이구하기
SELECT PROFESSOR_NAME "교수이름", 
EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(PROFESSOR_SSN, 8, 1), '1', '19','2','19') || SUBSTR(PROFESSOR_SSN, 1, 2) +1) "나이" 
-- 만 나이 X
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 2;


/* [↓ 문제풀이]
 MONTHS_BETWEEN 사용하여 만 나이 구하기
 MONTHS_BETWEEN / FLOOR 사용  */
SELECT PROFESSOR_NAME, 
	FLOOR(MONTHS_BETWEEN( SYSDATE, TO_DATE(19 || SUBSTR(PROFESSOR_SSN, 1, 6)))/ 12) "만 나이" 
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY 2; 


-- 4. 교수들의 성을 제외한 이름을 조회 
SELECT SUBSTR(PROFESSOR_NAME, 2) 이름
FROM TB_PROFESSOR;


-- 5. 재수생 입학자 조회 (20살 이후 입학한 학생, 19살 입학은 재수X)
SELECT STUDENT_NO, STUDENT_NAME 
FROM TB_STUDENT 
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) 
	- EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,6))) > 19;


-- 6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('20201225'), 'day') 
FROM DUAL;

-- 7. 
SELECT TO_DATE('99/10/11', 'YY/MM/DD') FROM DUAL;
-- 2099-10-11 00:00:00.000

SELECT TO_DATE('49/10/11', 'YY/MM/DD') FROM DUAL;
-- 2049-10-11 00:00:00.000

SELECT TO_DATE('99/10/11', 'RR/MM/DD') FROM DUAL;
-- 1999-10-11 00:00:00.000

SELECT TO_DATE('49/10/11', 'RR/MM/DD') FROM DUAL;
-- 2049-10-11 00:00:00.000



-- 8. 2000년도 이후 입학자들은 학번이 A로 시작한다
-- 	2000년도 이전 학번을 받은 학생들의 학번과 이름 조회
SELECT STUDENT_NO, STUDENT_NAME 
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';


-- 9. 학번 A517178 한아름 학생의 학점 총 평균 구하기
--	  (점수는 반올림하여 소수점 이하 한 자리까지 표시) 
SELECT ROUND(AVG(POINT), 1) 평점
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A517178'


-- 10. 학과별로 학생수를 구하여 "학과번호", "학생수(명)" 조회
SELECT DEPARTMENT_NO "학과번호", COUNT(*) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO 
ORDER BY 1;


-- 11. 지도교수를 배정받지 못한 학생의 수
SELECT COUNT (*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;


-- 12. 학번 A112113 김고운 학생의 년도 별 평점
--	   출력헤드는 "년도", "년도 별 평점" / 점수는 반올림하여 소수점 이하 한 자리
SELECT SUBSTR(TERM_NO, 1,4) 년도, ROUND(AVG(POINT),1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1,4)
ORDER BY 1;


-- *** 13. 학과별 휴학생 수 조회
--     출력헤드는 학과코드명, 휴학생 수
SELECT DEPARTMENT_NO "학과코드명", COUNT(DECODE(ABSENCE_YN,'Y',1)) "휴학생 수"
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO
ORDER BY 1;


-- 14. 춘 대학교에 다니는 동명이인
SELECT STUDENT_NAME 동일이름, COUNT(*) " 동명인 수"
FROM TB_STUDENT 
GROUP BY STUDENT_NAME 
HAVING COUNT(*) >=2
ORDER BY 1;


-- 15. 학번 A112113 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점


SELECT NVL(SUBSTR(TERM_NO,1,4), ' ') 년도, NVL(SUBSTR(TERM_NO,5,2), ' ') 학기, ROUND(AVG(POINT),1)  
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO,5,2));
