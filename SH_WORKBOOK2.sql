-- [Additional SELECT - OPTION]

-- 1. 학생 이름과 주소지 (이름의 오름차순으로 정렬)
SELECT STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소지
FROM TB_STUDENT 
ORDER BY 학생이름;


-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 조회
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT 
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;


-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름, 학번, 주소 조회
-- (이름의 오름차순으로 출력, 출력헤더 변경)
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT 
WHERE (STUDENT_ADDRESS LIKE ('경기%') OR STUDENT_ADDRESS LIKE ('강원%'))
AND SUBSTR(STUDENT_NO, 1, 2) LIKE ('9%')
ORDER BY 학생이름;


-- 4. 법학과 교수 중 가장 나이가 많은 사람부터 이름을 조회
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_PROFESSOR 
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY 2 ;



-- 5. 2004년 2학기에 'C3118100'과목을 수강한 학생들의 *학점(소수점 둘째자리)을 조회 
-- 학점이 높은 순으로 정렬하고, 학점이 같으면 학번이 낮은 순으로 조회
SELECT STUDENT_NO, TO_CHAR(POINT, 'FM9.00')  -- TO_CHAR(NUMBER, 'FM9.00')
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;


-- 6. 학생 번호, 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL문
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
ORDER BY 2;


-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);


-- ** 8. 과목별 교수 이름을 과목 이름과 교수 이름으로 출력
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
RIGHT JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
GROUP BY CLASS_NAME, PROFESSOR_NAME


-- 9. 8번의 결과 중 '인문 사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다.
-- 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.


-- 10. '음악학과' 학생들의 평점을 구하려고 한다. 
-- 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT STUDENT_NO 학번, STUDENT_NAME "학생 이름", ROUND(AVG(POINT),1) "전체 평점"
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY 1;


-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 
-- 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생이름과 지도 교수 이름이 필요하다.
-- 단, 출력헤더는 “학과이름”, “학생이름”, “지도교수이름” 으로 출력되도록 한다.
SELECT DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(PROFESSOR_NO=COACH_PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';


-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 출력
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO, 1, 4) = '2007'
AND CLASS_NAME = '인간관계론';


-- **13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아
--    그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.

SELECT CLASS_NAME, DEPARTMENT_NAME 
FROM TB_CLASS 
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_STUDENT USING(DEPARTMENT_NO)
LEFT JOIN TB_CLASS_PROFESSOR ON(PROFESSOR_NO = COACH_PROFESSOR_NO)
WHERE CATEGORY = '예체능'
AND COACH_PROFESSOR_NO IS NULL;


-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다.
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정"으로 표시
-- 단 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON(PROFESSOR_NO = COACH_PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;



--15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과이름, 평점 출력
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME, AVG(POINT)
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 1;



-- 16. 환경조경학과 *전공*과목들의 과목별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
JOIN TB_GRADE USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과'
AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;


-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소 출력

SELECT STUDENT_NAME, STUDENT_ADDRESS 
FROM TB_STUDENT 
WHERE DEPARTMENT_NO IN (SELECT DEPARTMENT_NO
						FROM TB_STUDENT ts 
						WHERE STUDENT_NAME = '최경희');
					
					
-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오

					
					
					
					
-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시, 평점은 소수점 한자리까지만 반올림 