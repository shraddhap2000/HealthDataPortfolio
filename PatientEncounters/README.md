Patient Encounters Analysis 

Business Problem:    
Leadership needs visibility into how often patients with chronic conditions (specifically Diabetes and Hypertension) visit each health center. The goal is to identify centers with higher chronic-disease burden and assess where additional resources or care programs may be needed.

Objectives
1. Calculate total patient visits per health center.
2. Identify how many visits involve chronic disease patients.
3. Determine the percentage of encounters involving chronic disease.
4.Produce a clear, visual summary for executive review.

Methodology,
1. Queried patient encounter data using SQL.
2. Joined three core tables: encounters, organizations, and conditions.
3. Used aggregate functions, CASE logic, and filtering for chronic conditions.
4. Exported cleaned output to Excel for easier Tableau connection.
5. Built three bar charts visualizing total visits, chronic disease encounters, and chronic-disease visit percentages.

**SQL Skills Used: CTEs, Joins, Aggregate functions (COUNT), CASE statements, Filtering and grouping, Ordered output for reporting

Key Insights: 
1. Certain centers had significantly higher percentages of chronic-disease visits, indicating heavier long-term care demands.
2. Some centers had high visit volume but lower chronic-disease percentages, suggesting a larger general-care population.
3. The percentage metric provided a clearer comparison than raw visit counts, helping focus attention on chronic-care intensity rather than total traffic.
