/*
SQL Course - CASE Lesson
We can add a new calculated columns and use CASE as a switch between options.
*/

/*
A "simple form" CASE statement based on the values of a single column
*/

SELECT
	ps.PatientId
	, ps.Hospital
	, CASE
		ps.Hospital
	    WHEN 'PRUH' THEN 'Princess Royal University Hospital'
		WHEN 'Oxleas' THEN 'Oxleas NHS Foundation Trust'
		ELSE 'Other'
	END AS HospitalGroup
	, ps.Ward
FROM
	dbo.PatientStay ps
ORDER BY
	HospitalGroup;

/*
A "searched form" CASE statement based on a boolean condition
*/

SELECT
	ps.PatientId
	, ps.Hospital
	, ps.Ward
	, CASE
		WHEN ps.Ward LIKE '%Surgery' THEN 'Surgical'
		WHEN ps.Ward IN ('Accident', 'Emergency', 'Ophthalmology') THEN 'A&E'
		ELSE 'General'
	END AS WardType
FROM
	dbo.PatientStay ps
ORDER BY WardType;

/*
 * A common pattern is to use a SUM(CASE ... WHEN ... THEN 1 ELSE 0 END) calculation 
 * to count where the number of rows where a condition occurs
 */

SELECT
	ps.Hospital
	, COUNT(*) AS NumberOfPatients
	, SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
	, (100 * SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END)) / COUNT(*) * 1.0 AS PercentageOfPatientsInSurgery
FROM
	dbo.PatientStay ps
GROUP BY ps.Hospital 
ORDER BY ps.Hospital 

-- CTE version -- Common Table expression

; With cte AS(
    SELECT
	ps.Hospital
	, COUNT(*) AS NumberOfPatients
	, SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery

FROM
	dbo.PatientStay ps
GROUP BY ps.Hospital 
 )

Select 
cte.Hospital,
cte.NumberOfPatients,
cte.NumberOfPatientsInSurgery,
100.0 * cte.NumberOfPatientsInSurgery / cte.NumberOfPatients AS PercentageOfPatientsInSurgery
from cte

/** TEMP table approach ***/
    SELECT
	ps.Hospital
	, COUNT(*) AS NumberOfPatients
	, SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
into #TempPatientStay
FROM
	dbo.PatientStay ps
GROUP BY ps.Hospital 

Select * from #TempPatientStay

Drop #

Select 
    t.Hospital,
    t.NumberOfPatients,
    t.NumberOfPatientsInSurgery,
    100.0 * t.NumberOfPatientsInSurgery/ t.NumberOfPatients as percentageofpatientsinsurgery
from #TempPatientStay t

 

Select 
cte.Hospital,
cte.NumberOfPatients,
cte.NumberOfPatientsInSurgery,
100.0 * cte.NumberOfPatientsInSurgery / cte.NumberOfPatients AS PercentageOfPatientsInSurgery
from cte

SELECT
	ps.Hospital
	, COUNT(*) AS NumberOfPatients
	, SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery

FROM
	dbo.PatientStay ps
GROUP BY ps.Hospital 
ORDER BY ps.Hospital 

Select 12 * 1.0 /13 

/*** Sub Query Approach ***/


SELECT * from ( Select

    ps.Hospital    
	, COUNT(*) AS NumberOfPatients
	, SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
    Round (100.0 * t.NumberOfPatientsInSurgery/t.NumberOfPatients, 1) as 

FROM
	dbo.PatientStay ps
GROUP BY ps.Hospital ) As Subquery


/** Round func **/
-- Mark W code --
SELECT
    t.Hospital
    ,t.NumberOfPatients
    ,t.NumberOfPatientsInSurgery
    , ROUND(100.0 * t.NumberOfPatientsInSurgery / t.NumberOfPatients, 1) AS PercentageOfPatientsInSurgery
 FROM (
SELECT
    ps.Hospital
    , COUNT(*) AS NumberOfPatients
    , SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
FROM
    dbo.PatientStay ps
GROUP BY ps.Hospital ) AS t
 
 --- can use Round via a FORMAT function as well -- 

/*
Optional advanced section
 
A more complex "searched form" CASE syntax statement  for more general cases
Assume that the Financial Year starts on March 1st
*/
SELECT
    ps.PatientId
    , ps.AdmittedDate
    , CASE
        WHEN DATEPART(MONTH, ps.AdmittedDate) >= 3 -- March or later in the year
    THEN     CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate), '-', DATEPART(YEAR, ps.AdmittedDate) + 1)
        ELSE CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate) - 1, '-', DATEPART(YEAR, ps.AdmittedDate))
    END AS FinancialYear
FROM dbo.PatientStay ps
WHERE ps.Hospital = 'PRUH'
ORDER BY ps.AdmittedDate,
         ps.PatientId;