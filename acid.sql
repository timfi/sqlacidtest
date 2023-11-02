-- provide test results here
with testresults as (
  
select 1 as test, result from (
-- sql/test001.sql



select case when queryresult = 11 then 'T' else 'F' end as result
from (


select sum(x) as queryresult
from (values(1),(2),(4),(8),(NULL)) s(x)
where exists(select * from (values(2),(8)) t(y) where x=y) or (x<3)

) test
) testcase(result) UNION ALL select 2 as test, result from (
-- sql/test002.sql


SELECT case when CAST (4.8 AS INTEGER) = 5 AND CAST(4.2 AS INTEGER) = 4 then 'T' else 'F' end as result
) testcase(result) UNION ALL select 3 as test, result from (
-- sql/test003.sql



select case when (r1=5) and (r2=40) then 'T' else 'F' end as result
from (


select sum(case when m then i else 0 end) as r1, sum(case when m is null then i else 0 end) r2
from (
select i, x=some(select a from (values(1,1),(2,2),(3,3),(4,4),(NULL,5)) t(a,b) where b<y) as m
from (values(1,4,1),(2,2,2),(4,6,4),(8,8,8),(NULL,0,16),(NULL,8,32)) s(x,y,i)
) s

) test
) testcase(result) UNION ALL select 4 as test, result from (
-- sql/test004.sql


SELECT case when '' IS NOT NULL then 'T' else 'F' end AS result
) testcase(result) UNION ALL select 5 as test, result from (
-- sql/test005.sql



select case when count(x)=8 then 'T' else 'F' end as result
from (
(values(1,NULL,2),(1,NULL,3),(2,1,NULL),(2,NULL,2),(2,NULL,3),(3,1,NULL),(3,2,2),(3,NULL,3)) expected(a,b,c)
left outer join (



select * from (values(1),(2),(3)) s(x), lateral (select * from (select * from (values(1),(2)) a(y) where y<x) a full outer join (values(2),(3)) b(z) on y=z) t


) t on a is not distinct from x and b is not distinct from y and c is not distinct from z
) test
) testcase(result) UNION ALL select 6 as test, result from (
-- sql/test006.sql



select case when s*10000000000000000 = 100000000000000 then 'T' else 'F' end as result
from (



select sum(x)/10 as s from (values(0.2),(0.2),(-0.3)) s(x)


) test
) testcase(result) UNION ALL select 7 as test, result from (
-- sql/test007.sql



select case when (count(*) = 3) and (count(x) = 3) then 'T' else 'F' end as result
from (
(values(2,2),(3,1),(4,1)) expected(a,b)
full outer join (



select x, count(*) as c
from ((select * from (values(1),(2),(2),(3),(3),(3),(4),(4),(4),(4)) s(x) except all select * from (values(1),(3),(3)) t(x)) intersect all select * from (values(2),(2),(2),(4),(3),(3)) u(x)) s
group by x

) s on (x=a and c=b)
) test
) testcase(result) UNION ALL select 8 as test, result from (
-- sql/test008.sql



select case when s = 'abcdef' then 'T' else 'F' end as result
from (


values ('abc' || 'def')

) t(s)
) testcase(result) UNION ALL select 9 as test, result from (
-- sql/test009.sql


SELECT case when
	su = 70003 AND
	mi = 20001 AND
	ma = 30001 AND
	av BETWEEN 23334.3 AND 23334.4 AND
	ct = 3 AND
	cs = 4 AND
	mis = '20001' AND
	mas = '30001' AND
	sd = 50002 AND
	cd = 2 AND
	CAST(ad as INTEGER) = 25001
	then 'T' else 'F' end AS result
FROM (

SELECT
	sum(x) as su, 
	min(x) as mi, 
	max(x) as ma,
	avg(x) as av, 
	count(x) as ct, 
	count(*) as cs, 
	min(CAST (x as VARCHAR(10))) as mis, 
	max(CAST (x as VARCHAR(10))) as mas,
	sum(distinct x) as sd, 
	count(distinct x) as cd,
	avg(distinct x) as ad

FROM (VALUES(CAST(30001 AS SMALLINT)), (CAST(20001 AS SMALLINT)), (CAST(20001 AS SMALLINT)), (NULL)) s(x)

) test
) testcase(result) UNION ALL select 10 as test, result from (
-- sql/test010.sql


SELECT case when CAST('123' AS char(4)) =  CAST('123 ' AS char(4))
         AND
       CAST('123' AS varchar(10))    <> CAST('123 ' AS varchar(10)) then 'T' else 'F' end AS result
) testcase(result) UNION ALL select 11 as test, result from (
-- sql/test011.sql
SELECT case when AVG(x)>0 then 'T' else 'F' end AS result
FROM (
	SELECT CAST(9223372036854775807 AS BIGINT) AS x
	UNION ALL
	SELECT CAST(9223372036854775807 AS BIGINT)
) AS t
) testcase(result) UNION ALL select 12 as test, result from (
-- sql/test012.sql

SELECT case when (SELECT SUM(x))=42 then 'T' else 'F' end AS result
FROM (VALUES (42)) AS t(x)
) testcase(result) UNION ALL select 13 as test, result from (
-- sql/test013.sql



select case when (state='924875136138624795765391842546713928812469357397582614651238479489157263273946581') then 'T' else 'F' end as result
from (



with recursive
   digits(value,ch) as (values(1,'1'),(2,'2'),(3,'3'),(4,'4'),(5,'5'),(6,'6'),(7,'7'),(8,'8'),(9,'9')),
   sudoku(state, next) as
   (select state, position(' ' in state) as next
    from (select '9     1 6   62 79   5  1   54     2 81  6935739 5826 46      7   915   32 3 46   ') s(state)
   union all
   select state, position(' ' in state) as next
   from (select substring(state from 1 for next-1) || try || substring(state from next+1) as state
         from sudoku, (select ch as try from digits) g
         where next > 0 and
         not exists(select 1 from (select value as pos from digits) s
                    where try = substring(state from cast(floor((next-1)/9) as integer)*9+pos for 1)
                    or    try = substring(state from mod((next-1),9)+9*pos-8 for 1)
                    or    try = substring(state from mod(cast(floor((next-1)/3) as integer),3)*3+cast(floor((next-1)/27) as integer)*27+pos+cast(floor((pos-1)/3) as integer)*6 for 1))
        ) c)
select state from sudoku where next=0

) test
) testcase(result) UNION ALL select 14 as test, result from (
-- sql/test014.sql

select case when (
	
	(1+2*3) = (1+(2*3)) and

	
	(2-3/4) = (2-(3/4)) and

	
	(2/3/3) = ((2/3)/3) and
	(2/3*3) = ((2/3)*3) and

	
	(1+2 < 2+2) = ((1+2) < (2+2))  and
	(1+2 <= 1+2) = ((1+2) <= (1+2))  and
	(2+2 > 1+2) = ((2+2) > (1+2))  and
	(2+2 >= 1+2) = ((2+2) >= (1+2))  and
	(2+2 <> 1+2) = ((2+2) <> (1+2))	and

	
	(2 between 2-1 and 2+1) and
	(2 + 3 in (3+2)) and

	
	(not true or true) = ((not true) or true)
) then 'T' else 'F' end as result
) testcase(result) UNION ALL select 15 as test, result from (
-- sql/test015.sql

SELECT case when
    NULL OR x>0
    AND
    NOT (NULL AND x<0) then 'T' else 'F' end AS result
FROM (VALUES (42)) AS t(x)
) testcase(result) UNION ALL select 16 as test, result from (
-- sql/test016.sql

SELECT
  CASE WHEN
        CAST(NULL AS CHARACTER) IS NULL
    AND CAST(NULL AS NUMERIC) IS NULL
    AND CAST(NULL AS DECIMAL) IS NULL
    AND CAST(NULL AS SMALLINT) IS NULL
    AND CAST(NULL AS INTEGER) IS NULL
    AND CAST(NULL AS INT) IS NULL
    AND CAST(NULL AS BIGINT) IS NULL
    AND CAST(NULL AS FLOAT) IS NULL
    AND CAST(NULL AS REAL) IS NULL
    AND CAST(NULL AS DOUBLE PRECISION) IS NULL
    AND CAST('T' AS BOOLEAN) <> CAST('F' AS BOOLEAN)
  THEN 'T' ELSE 'F' END AS result
) testcase(result) UNION ALL select 17 as test, result from (
-- sql/test017.sql

SELECT CASE WHEN T.HeLlO=t.hello THEN 'T' ELSE 'F' END AS result
FROM (VALUES (42)) AS t(hello)
) testcase(result) UNION ALL select 18 as test, result from (
-- sql/test018.sql
select case when (1=1      
  AND 0 BETWEEN -1 AND 1
  AND 0.99 BETWEEN 0 AND 1    
                  
  AND 0 BETWEEN 0 AND 0
  AND 1 BETWEEN 0 AND 1
  AND 0 BETWEEN 0 AND 1 
                  
  AND -0 BETWEEN -0 AND +0
  AND -0.00 BETWEEN -0.00 AND +0.00
       
  AND 1.00 BETWEEN 0 AND 1.00           
  AND NOT 1.01 BETWEEN 0 AND 1
  
  AND 'a' BETWEEN 'a' AND 'b'
  AND 'ab' BETWEEN 'a' AND 'b'
  AND 'b' BETWEEN 'a' AND 'b'
  AND NOT 'bla' BETWEEN 'a' AND 'b'
  
  AND (NULL BETWEEN NULL AND NULL) IS NULL 
  AND (NULL BETWEEN 0 AND NULL) IS NULL 
  AND (0 BETWEEN 0 AND NULL) IS NULL 
  AND (NULL BETWEEN 0 AND 1) IS NULL 
  
  
  AND TRUE BETWEEN FALSE AND TRUE
  AND FALSE BETWEEN FALSE AND TRUE
    
) then 'T' else 'F' end as result;
) testcase(result) UNION ALL select 19 as test, result from (
-- sql/test019.sql

SELECT CASE WHEN (
  CAST(' 1  ' AS NUMERIC) =  1   AND
  CAST(' 1. ' AS NUMERIC) =  1.  AND
  CAST(' 1.2' AS NUMERIC) =  1.2 AND
  CAST('  .2' AS NUMERIC) =   .2 AND

  CAST('+1  ' AS NUMERIC) = +1   AND
  CAST('+1. ' AS NUMERIC) = +1.  AND
  CAST('+1.2' AS NUMERIC) = +1.2 AND
  CAST('+.2'  AS NUMERIC) =  +.2 AND

  CAST('-1  ' AS NUMERIC) = -1   AND
  CAST('-1. ' AS NUMERIC) = -1.  AND
  CAST('-1.2' AS NUMERIC) = -1.2 AND
  CAST('-.2'  AS NUMERIC) =  -.2 AND

  CAST(' 1.2E3' AS NUMERIC) =  1.2E3 AND
  CAST('+1.2E3' AS NUMERIC) = +1.2E3 AND
  CAST('-1.2E3' AS NUMERIC) = -1.2E3 AND

  CAST(' 1.2E+3' AS NUMERIC) =  1.2E+3 AND
  CAST('+1.2E+3' AS NUMERIC) = +1.2E+3 AND
  CAST('-1.2E+3' AS NUMERIC) = -1.2E+3 AND

  CAST(' 1.2E-3' AS NUMERIC) =  1.2E-3 AND
  CAST('+1.2E-3' AS NUMERIC) = +1.2E-3 AND
  CAST('-1.2E-3' AS NUMERIC) = -1.2E-3
) THEN 'T' ELSE 'F' END
FROM (VALUES (1)) something
) testcase(result) UNION ALL select index as test, 'T' as result from generate_series(20,260) s(index) 
)
-- render the result
select case when state = 1048575 then image else 'XXXXXXXXXXXXXXXXXXXX' end as output from (values
(0, '+-----------------+'),
(1, '|......#####......|'),
(2, '|....##.....##....|'),
(3, '|...#.........#...|'),
(4, '|..#..()...()..#..|'),
(5, '|..#.....o.....#..|'),
(6, '|.#.............#.|'),
(7, '|..#..\...../..#..|'),
(8, '|..#...-----...#..|'),
(9, '|...#.........#...|'),
(10,'|....##.....##....|'),
(11,'|......#####......|'),
(12,'+-----------------+')
) image(line, image) left outer join (
select line, sum(cast(power(2,ofs) as integer)) as state
  from (select line, test-1-20*line as ofs, test, result
  from (select cast(floor((test-1)/20) as integer) as line, test, result from testresults where result = 'T') s
  ) s group by line) s
on image.line=s.line order by image.line;
