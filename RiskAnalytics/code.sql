--hcc_weight is numeric
UPDATE joined_data
SET hcc_weight = NULL
WHERE ISNUMERIC(hcc_weight) = 0;

UPDATE icd_mapping
SET hcc_weight = NULL
WHERE ISNUMERIC(hcc_weight) = 0;

-- hcc_weight columns to DECIMAL
ALTER TABLE joined_data
ALTER COLUMN hcc_weight DECIMAL(5,2);
ALTER TABLE icd_mapping
ALTER COLUMN hcc_weight DECIMAL(5,2);

--Total sickness score per patient
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
)
SELECT member_id AS PatientID,
       SUM(max_weight) AS TotalSicknessScore
FROM max_per_category
GROUP BY member_id
ORDER BY TotalSicknessScore DESC;

--Total number of claims per patient
SELECT member_id AS PatientID,
       COUNT(claim_id) AS TotalClaims
FROM joined_data
GROUP BY member_id
ORDER BY TotalClaims DESC;

--Number of unique diagnoses per patient
SELECT member_id AS PatientID,
       COUNT(DISTINCT icd_code) AS UniqueDiagnoses
FROM joined_data
GROUP BY member_id
ORDER BY UniqueDiagnoses DESC;

-- Provider-level sickness summary (sum, count, average)
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
),
patient_sickness AS (
    SELECT member_id,
           SUM(max_weight) AS total_sickness_score
    FROM max_per_category
    GROUP BY member_id
)
SELECT 
       c.provider_id AS ProviderID,
       SUM(ps.total_sickness_score) AS TotalSickness,
       COUNT(DISTINCT ps.member_id) AS TotalPatients,
       AVG(ps.total_sickness_score) AS AvgSicknessPerPatient
FROM claims c
INNER JOIN patient_sickness ps
    ON c.member_id = ps.member_id
WHERE c.provider_id IS NOT NULL
GROUP BY c.provider_id
ORDER BY TotalSickness DESC;

-- patients per risk level
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
),
patient_sickness AS (
    SELECT member_id,
           SUM(max_weight) AS total_sickness_score
    FROM max_per_category
    GROUP BY member_id
),
risk_levels AS (
    SELECT member_id,
           CASE 
               WHEN total_sickness_score < 1.0 THEN 'Low'
               WHEN total_sickness_score < 2.0 THEN 'Medium'
               ELSE 'High'
           END AS RiskLevel
    FROM patient_sickness
)
SELECT RiskLevel,
       COUNT(member_id) AS NumPatients
FROM risk_levels
GROUP BY RiskLevel
ORDER BY NumPatients DESC;

--Total patients per major condition (hcc_group)
SELECT
    COALESCE(i.hcc_group, 'Unmapped/Undiagnosed') AS ConditionCategory,
    COUNT(DISTINCT c.member_id) AS total_patients
FROM claims c
LEFT JOIN diagnoses d ON c.claim_id = d.claim_id
LEFT JOIN icd_mapping i ON d.icd_code = i.icd_code
GROUP BY COALESCE(i.hcc_group, 'Unmapped/Undiagnosed')
ORDER BY total_patients DESC;


--Estimated Cost of Care Per Patient 
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i 
           ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
),
patient_sickness AS (
    SELECT member_id,
           SUM(max_weight) AS total_sickness_score
    FROM max_per_category
    GROUP BY member_id
)
SELECT member_id,
       (total_sickness_score * 3000) AS cost_of_care
FROM patient_sickness
ORDER BY cost_of_care DESC;

-- average score per age group 
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i 
        ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
),

patient_sickness AS (
    SELECT member_id,
           SUM(max_weight) AS total_sickness_score
    FROM max_per_category
    GROUP BY member_id
)
SELECT
    CASE 
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 0 AND 20 THEN '0-20'
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 21 AND 40 THEN '21-40'
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '61+'
    END AS AgeBracket,
    AVG(ps.total_sickness_score) AS AvgSicknessScore
FROM patient_sickness ps
JOIN members m 
    ON ps.member_id = m.member_id
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 0 AND 20 THEN '0-20'
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 21 AND 40 THEN '21-40'
        WHEN DATEDIFF(YEAR, m.dob, GETDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '61+'
    END
ORDER BY AgeBracket;

-- # of high risk patients per provider 
WITH max_per_category AS (
    SELECT jd.member_id,
           i.hcc_group,
           MAX(i.hcc_weight) AS max_weight
    FROM joined_data jd
    LEFT JOIN icd_mapping i 
        ON jd.icd_code = i.icd_code
    GROUP BY jd.member_id, i.hcc_group
),
patient_sickness AS (
    SELECT member_id,
           SUM(max_weight) AS total_sickness_score
    FROM max_per_category
    GROUP BY member_id
),
patient_risk AS (
    SELECT member_id,
           total_sickness_score,
           CASE
               WHEN total_sickness_score < 1.0 THEN 'Low'
               WHEN total_sickness_score < 2.0 THEN 'Medium'
               ELSE 'High'
           END AS RiskLevel
    FROM patient_sickness
)
SELECT 
    c.provider_id AS ProviderID,
    COUNT(DISTINCT pr.member_id) AS HighRiskPatients
FROM claims c
JOIN patient_risk pr 
    ON c.member_id = pr.member_id
WHERE pr.RiskLevel = 'High'
GROUP BY c.provider_id
ORDER BY HighRiskPatients DESC;

--patients with missing conditions 
WITH patient_hcc AS (
    SELECT 
        jd.member_id,
        i.hcc_group
    FROM joined_data jd
    LEFT JOIN icd_mapping i 
        ON jd.icd_code = i.icd_code
)
SELECT 
    member_id
FROM patient_hcc
WHERE hcc_group IS NULL
GROUP BY member_id;


