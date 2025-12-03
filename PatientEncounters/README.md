Patient Encounters Analysis 

Business Problem:    
Leadership needs visibility into how often patients with chronic conditions (specifically Diabetes and Hypertension) visit each health center. The goal is to identify centers with higher chronic-disease burden and assess where additional resources or care programs may be needed.

Objectives 
1. Calculate total patient visits per health center.
2. Identify how many visits involve chronic disease patients.
3. Determine the percentage of encounters involving chronic disease.
4. Produce a clear, visual summary for executive review.

Methodology ([SQL Code](./query.sql))
1. Queried patient encounter data using SQL.
2. Joined three core tables: encounters, organizations, and conditions.
3. Used aggregate functions, CASE logic, and filtering for chronic conditions.
4. Exported cleaned output to Excel for easier Tableau connection.
5. Built three bar charts visualizing total visits, chronic disease encounters, and chronic-disease visit percentages.

**SQL Skills Used: CTEs, Joins, Aggregate Functions, CASE statements, Filtering and Grouping, Ordered output for reporting

Key Insights: 
1. Total Patients by Center. High-volume centers experience the greatest operational load, indicating potential need for additional staffing, expanded appointment availability, or workflow optimization.
2. Top 10 Centers by Chronic Disease Patients. A small subset of centers manages a disproportionate share of chronic disease encounters. These locations represent high-priority targets for chronic care programs, preventive outreach, and resource allocation.
3. Top 10 Centers by Chronic Visit Burden. A limited number of centers account for a large portion of chronic-disease visit volume. These centers may benefit from improved chronic-care workflows, targeted provider support, and initiatives aimed at reducing repeated high-burden encounters.


<img width="1197" height="782" alt="Dashboard" src="https://github.com/user-attachments/assets/592dd6e8-69d8-48fe-8e05-da08768b8597" />

Recommendations:
- Strengthen chronic-care resources at centers with the highest burden.
- Prioritize case-management for high-utilization populations.
- Adjust staffing and scheduling at centers with heavy visit volume.
- Focus improvement efforts on centers with the greatest operational strain.

Next Steps:
- Add demographics and risk factors for deeper analysis.
- Incorporate cost/outcome data to assess impact.
- Build time-trend dashboards to track changes over time.
- Expand metrics to include no-shows, follow-ups, and referrals.
