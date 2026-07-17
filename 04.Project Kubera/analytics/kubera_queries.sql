-- ============================================================
-- Project Kubera — Business Intelligence Queries
-- 5 queries covering Portfolio, AI Decisions, Collections, P&L, Compliance
-- ============================================================

-- Q1: Portfolio Overview — Product Mix & NPA Analysis
-- Used in: Act 1 — CEO Morning Dashboard
SELECT 
    p.product_name,
    p.product_type,
    COUNT(*) AS loan_count,
    SUM(l.disbursed_amount) AS total_disbursed,
    ROUND(AVG(l.interest_rate), 2) AS avg_interest_rate,
    SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) AS npa_amount,
    ROUND(SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) * 100.0 / NULLIF(SUM(l.disbursed_amount), 0), 2) AS npa_pct
FROM fact_loans l
JOIN dim_product p ON l.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.product_type
ORDER BY total_disbursed DESC;

/* Sample Output:
 product_name         | type        | count | disbursed   | yield | npa_amount | npa_pct
----------------------+-------------+-------+-------------+-------+------------+--------
 Home Loan            | Home Loan   | 1     | 1500000.00  | 8.50  | 0.00       | 0.00
 Gold Loan            | Gold Loan   | 1     | 800000.00   | 12.20 | 0.00       | 0.00
 MSME Working Capital | MSME Loan   | 1     | 0.00        | 11.80 | 0.00       | 0.00
 Vehicle Loan         | Vehicle Loan| 1     | 0.00        | 10.50 | 0.00       | 0.00
 Personal Loan        | Personal Loan| 1    | 0.00        | 14.50 | 0.00       | 0.00
*/

-- Q2: AI Decision Engine Performance & Override Analysis
-- Used in: Act 4 — Credit Risk & AI Decision Center + Act 8 — AI Strategy
SELECT 
    ai_decision,
    COUNT(*) AS total_decisions,
    SUM(CASE WHEN human_override THEN 1 ELSE 0 END) AS overrides,
    ROUND(SUM(CASE WHEN human_override THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS override_pct,
    ROUND(AVG(ai_confidence), 1) AS avg_confidence,
    SUM(CASE WHEN outcome_status = 'On track' THEN 1 ELSE 0 END) AS on_track,
    SUM(CASE WHEN outcome_status = 'Early delinquency' THEN 1 ELSE 0 END) AS early_delinquency
FROM fact_ai_decisions
WHERE decision_date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY ai_decision
ORDER BY total_decisions DESC;

/* Sample Output:
 ai_decision | total | overrides | override_pct | avg_conf | on_track | delinq
-------------+-------+-----------+--------------+----------+----------+--------
 Approve     | 3     | 0         | 0.0          | 90.7     | 3        | 0
 Reject      | 1     | 1         | 100.0        | 89.0     | 1        | 0
 Conditional | 1     | 0         | 0.0          | 71.0     | 0        | 0
*/

-- Q3: Collections Bucket Aging with AI Recovery Scoring
-- Used in: Act 5 — Collections & Recovery
SELECT 
    c.bucket,
    COUNT(*) AS accounts,
    SUM(c.overdue_amount) AS total_overdue,
    ROUND(AVG(c.days_overdue), 0) AS avg_days_overdue,
    ROUND(AVG(c.ai_recovery_prob), 0) AS avg_recovery_prob,
    SUM(c.recovery_amount) AS total_recovered,
    ROUND(SUM(c.recovery_amount) * 100.0 / NULLIF(SUM(c.overdue_amount), 0), 1) AS recovery_pct,
    CASE c.bucket
        WHEN '1-30' THEN 'SMS + Auto-call'
        WHEN '31-60' THEN 'Agent call + email'
        WHEN '61-90' THEN 'Field visit + legal notice'
        WHEN '91-180' THEN 'Legal + settlement offer'
        ELSE 'NPA + recovery tribunal'
    END AS strategy
FROM fact_collections c
GROUP BY c.bucket
ORDER BY 
    CASE c.bucket
        WHEN '1-30' THEN 1
        WHEN '31-60' THEN 2
        WHEN '61-90' THEN 3
        WHEN '91-180' THEN 4
        ELSE 5
    END;

/* Sample Output:
 bucket  | accounts | overdue    | avg_days | avg_prob | recovered | recovery% | strategy
---------+----------+------------+----------+----------+-----------+-----------+-------------------------
 1-30    | 0        | 0.00       | 0        | 0        | 0.00      | 0.0       | SMS + Auto-call
 31-60   | 0        | 0.00       | 0        | 0        | 0.00      | 0.0       | Agent call + email
 61-90   | 1        | 420000.00  | 67       | 82       | 0.00      | 0.0       | Field visit + legal notice
 91-180  | 1        | 850000.00  | 124      | 34       | 0.00      | 0.0       | Legal + settlement offer
*/

-- Q4: P&L Waterfall — Quarterly
-- Used in: Act 6 — Portfolio Health & Profitability
SELECT 
    payment_type,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS income,
    SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS expense,
    SUM(amount) AS net
FROM fact_payments
WHERE quarter = 'Q2' AND fy_year = 'FY2026'
GROUP BY payment_type
ORDER BY net DESC;

/* Sample Output:
 payment_type      | income      | expense     | net
-------------------+-------------+-------------+------------
 Interest Income   | 172000000.00| 0.00        | 172000000.00
 Fee Income        | 28000000.00 | 0.00        | 28000000.00
 Other Income      | 8000000.00  | 0.00        | 8000000.00
 Interest Expense  | 0.00        | 88000000.00 | -88000000.00
 Operating Expense | 0.00        | 42000000.00 | -42000000.00
 Provision         | 0.00        | 18000000.00 | -18000000.00
 Tax               | 0.00        | 12000000.00 | -12000000.00
*/

-- Q5: Branch Profitability & Risk Heatmap
-- Used in: Act 1 — Branch Heatmap + Act 6 — Branch Profitability
SELECT 
    b.branch_name,
    b.region,
    b.status,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(l.disbursed_amount) AS total_disbursed,
    SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) AS npa_amount,
    ROUND(SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) * 100.0 / NULLIF(SUM(l.disbursed_amount), 0), 2) AS npa_pct,
    SUM(p.amount) AS revenue,
    b.total_employees,
    CASE 
        WHEN b.status = 'Closure Recommended' THEN 'Loss'
        WHEN SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) * 100.0 / NULLIF(SUM(l.disbursed_amount), 0) > 4 THEN 'Critical'
        WHEN SUM(CASE WHEN l.status = 'NPA' THEN l.disbursed_amount ELSE 0 END) * 100.0 / NULLIF(SUM(l.disbursed_amount), 0) > 2.5 THEN 'Watch'
        ELSE 'On Track'
    END AS risk_status
FROM dim_branch b
LEFT JOIN fact_loans l ON b.branch_id = l.branch_id
LEFT JOIN fact_payments p ON b.branch_id = p.branch_id AND p.payment_type = 'Interest Income'
GROUP BY b.branch_id, b.branch_name, b.region, b.status, b.total_employees
ORDER BY total_disbursed DESC;

/* Sample Output:
 branch_name      | region           | status               | loans | disbursed   | npa_amount | npa_pct | revenue     | employees | risk_status
------------------+------------------+----------------------+-------+-------------+------------+---------+-------------+-----------+-------------
 Begumpet HQ      | Hyderabad Metro  | Active               | 1     | 1500000.00  | 0.00       | 0.00    | 98000000.00 | 45        | On Track
 Ameerpet         | Hyderabad Metro  | Active               | 0     | 0.00        | 0.00       | 0.00    | 0.00        | 38        | On Track
 ...
 Coimbatore South | Tamil Nadu       | Closure Recommended  | 1     | 0.00        | 0.00       | 0.00    | 0.00        | 14        | Loss
*/
