/*
* SQL Course - CASE Exercise - Start
*/

/* 
 * Create a new column HospitalLocation
 * Kings College is Urban, other hospitals are Rural 
 * Use the simple CASE form
*/

SELECT
	ps.PatientId
	, ps.Hospital,
	--, '???' AS HospitalLocation
    CASE
        when ps.hospital = 'Kings College' then 'Urban'
    else 'Rural'
    end AS HospitalLocation
FROM
	dbo.PatientStay ps
ORDER BY
	HospitalLocation;


--- / ** Chat gpt code ***/ ---


SELECT
    ps.PatientId,
    ps.Hospital,
    CASE
        WHEN ps.Hospital = 'Kings College' THEN 'Urban'
        ELSE 'Rural'
    END AS HospitalLocation
FROM
    dbo.PatientStay ps
ORDER BY
    HospitalLocation;

/* 
 * Create a new column WardType
 * Any ward that contains 'Surgery' is 'Surgical', otherwise 'Non Surgical'
 * Use the searched CASE form
*/

SELECT
	ps.PatientId
	, ps.Hospital
	, '???' AS WardType
FROM
	dbo.PatientStay ps
ORDER BY
	WardType

-- / EG exercise /--
SELECT
	ps.PatientId
	, ps.Hospital,
    ps.ward,
    CASE
         when ps.ward like '%Sur%' then 'Surgical'
        else 'Non Surgical'
    end AS WardType
    
FROM
	dbo.PatientStay ps
ORDER BY
	WardType


/*
 * Create a new column PatientTariffGroup
 * A patient with a Tariff of 7 or more is in the 'High Tariff' group
 * A patient with a Tariff of 4 or more but below 7 is in the 'Medium Tariff' group
 * A patient with a Tariff below 4 is is in the 'Low Tariff' group
 * 
 * Optional advanced question: how many patients are in each PatientTariffGroup?
 */
        
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, ps.Tariff,
    Case
        when ps.Tariff >= 7 then 'Hight Tariff'
        when ps.Tariff >=4 and ps.Tariff <=6 then 'Medium Tariff'
    Else 'Low tariff'
	end AS PatientTariffGroup
FROM
	dbo.PatientStay ps
ORDER BY
	PatientTariffGroup
	, ps.Tariff
	, ps.PatientId;