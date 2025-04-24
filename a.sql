/*

Foundation Recap Exercise
 
Use the table PatientStay.  

This lists 44 patients admitted to London hospitals over 5 days between Feb 26th and March 2nd 2024

*/
 
SELECT
	*
FROM
	PatientStay ps ;
 
/*

1. Filter the list the patients to show only those  -

a) in the Oxleas hospital,

b) and also in the PRUH hospital,

c) admitted in February 2024

d) only the surgical wards (i.e. wards ending with the word Surgery)
 
 
2. Show the PatientId, AdmittedDate, DischargeDate, Hospital and Ward columns only, not all the columns.

3. Order results by AdmittedDate (latest first) then PatientID column (high to low)

4. Add a new column LengthOfStay which calculates the number of days that the patient stayed in hospital, inclusive of both admitted and discharge date.

*/
 
-- Write the SQL statement here
SELECT
	*
FROM
	PatientStay ps 
where Hospital in ('Oxleas', 'PRUH')
AND AdmittedDate BETWEEN '01 fEB 2024' AND '01 mAR 2024'
AND WARD LIKE ('%sURGERY') 
 

 SELECT
	ps.PatientId,
    ps.AdmittedDate,
    ps.DischargeDate,
    ps.Hospital,
    ps.Ward,
    DATEDIFF(DAY, ps.AdmittedDate, ps.DischargeDate) as LOS
FROM
	PatientStay ps 
    Order by ps.AdmittedDate desc, ps.PatientId desc


/*\

5. How many patients has each hospital admitted? 

6. How much is the total tariff for each hospital?

7. List only those hospitals that have admitted over 10 patients

8. Order by the hospital with most admissions first

*/
 
-- Write the SQL statement here
 
/***********************************************************************/

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
		ELSE 'Other Hospitals'
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