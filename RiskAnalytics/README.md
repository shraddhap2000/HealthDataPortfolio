## Population Risk & Revenue Impact Analysis
### Business Problem: 
Healthcare organizations need to understand patient risk, condition burden, and provider-panel complexity to support care-management decisions and financial planning. Leadership lacked visibility into:
* How patient risk is distributed across the population,
* Which providers manage the highest-risk panels, and
* How risk-adjusted revenue compares to baseline revenue.
  
This analysis provides a structured view of clinical risk, coding completeness, and financial impact using the available data.

### Objectives:
1. Identify population-level risk patterns using Total Sickness Score (TSS).
2. Understand which provider panels carry the highest disease burden.
3. Measure potential financial impact using simple risk-adjusted revenue modeling.
4. Build clear Tableau dashboards that summarize findings for non-technical stakeholders.

### Methodology 
Data Preparation (SQL:CTEs, Joins, Window Functions, Aggregates, CASE, Filtering and Grouping)
* Cleaned and joined member, claims, and diagnoses data.
* Calculated Total Sickness Score (TSS) per patient.
* Built age brackets and provider-level aggregates.
* Identified patients with missing/unmapped conditions.
* Derived revenue metrics:
  1. Baseline revenue = total patients × $3,000 (assumption)
  2. Risk-adjusted revenue = SUM(TSS × 3,000)
  3. Missing-condition revenue = count_missing × avg_HCC_weight × 3,000

Visualization (Tableau)
* Built histograms, bar charts, calculated fields, treemaps, and KPIs. Did some filtering as well.

### Key Insights 
1. Population Risk Pattern: Most patients fall into lower TSS ranges, but a meaningful minority drive high-risk utilization. Ages 21–40 show the highest average TSS, indicating shifting disease burden toward younger adults.
2. Condition Prevalence: Chronic Kidney Disease, Hypertension, and Diabetes emerge as the top condition groups. These conditions explain a large portion of upward patient risk.
<img width="1413" height="819" alt="Screenshot 2025-12-02 213131" src="https://github.com/user-attachments/assets/8b941c9c-4112-419f-9332-d3924f26c092" />

3. Provider Panel Risk: Certain providers carry significantly higher average TSS panels. The top providers also manage the largest share of high-risk patients, suggesting targeted care-management value.
4. Financial Impact: Baseline revenue: $1.5M, Risk-adjusted revenue: $1.83M, Missing-condition opportunity: ≈ $186,300 (from patients lacking mapped conditions). Proper coding and risk capture meaningfully increase expected revenue.
<img width="1424" height="822" alt="Screenshot 2025-12-02 213425" src="https://github.com/user-attachments/assets/12103232-fb0c-4144-b10f-16769f463481" />

### Recommendations 
* Target high-risk provider panels with additional case management, chronic-care support, or operational resources.
* Improve diagnostic coding completeness, especially among the ~209 patients without mapped conditions.
* Develop outreach workflows for conditions driving risk (CKD, Diabetes, Hypertension).
* Monitor risk trends by age group as emerging patterns may impact future utilization.

### Next Steps 
* Incorporate time-series views: year-over-year risk changes.
* Compare actual cost data vs. modeled risk-adjusted reimbursement. 

