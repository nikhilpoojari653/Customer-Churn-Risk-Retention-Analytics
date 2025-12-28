create table customer_churn(
	customer_id varchar(20) primary key,
 	age int,
	gender varchar(10),
	city varchar(50),
	tenure_months int,
	plan_type varchar(20),
	monthly_charges numeric(10,2),
	payment_method varchar(20),
	auto_renew int check (auto_renew in (0,1)),
	last_payment_status varchar(10),
	avg_sessions_per_week numeric(10,2),
	avg_session_duration numeric(10,2),
	days_since_last_login int,
	feature_usage_score numeric(10,2),
	support_tickets int,
	avg_ticket_resolution_days numeric(10,2),
	complaints_flag int check (complaints_flag in (0,1)),
	churn int check (churn in (0,1))
);

COPY customer_churn
FROM 'C:\Users\Nikhil Poojari\Downloads\customer_churn_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM customer_churn;

---Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn;

---Churn by Plan Type
SELECT 
    plan_type,
    COUNT(*) AS customers,
    SUM(churn) AS churned,
    ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY plan_type
ORDER BY churn_rate_pct DESC;

---Usage vs Churn (Critical)
SELECT 
    churn,
    ROUND(AVG(avg_sessions_per_week), 2) AS avg_sessions,
    ROUND(AVG(feature_usage_score), 2) AS avg_feature_usage,
    ROUND(AVG(days_since_last_login), 2) AS avg_last_login_days
FROM customer_churn
GROUP BY churn;

---Tenure vs Churn
SELECT 
    CASE 
        WHEN tenure_months <= 3 THEN '0-3 months'
        WHEN tenure_months <= 12 THEN '4-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        ELSE '24+ months'
    END AS tenure_group,
    COUNT(*) AS customers,
    ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;












