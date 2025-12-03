SELECT 
    o.name AS Health_Center,
    
    -- Total visits per center
    COUNT(e.id) AS Total_Visits,
    
    -- Total encounters with chronic disease patients
    COUNT(CASE 
              WHEN c.description IN ('Diabetes','Hypertension') 
                AND c.description IS NOT NULL
			  THEN e.id 
          END) AS Chronic_Disease_Encounters,
    
    -- % of visits from chronic disease patients
    CASE 
        WHEN COUNT(e.id) = 0 THEN 0
        ELSE CAST(
                 COUNT(CASE 
                           WHEN c.description IN ('Diabetes','Hypertension') 
                           THEN e.id 
                       END) * 100.0 / COUNT(e.id) AS INT
             )
    END AS Percent_Chronic_Visits

FROM encounters e
JOIN organizations o
    ON e.organization = o.id
LEFT JOIN conditions c
    ON c.encounter = e.id
    AND c.description IN ('Diabetes','Hypertension')
    
GROUP BY o.name
ORDER BY Percent_Chronic_Visits DESC
     
