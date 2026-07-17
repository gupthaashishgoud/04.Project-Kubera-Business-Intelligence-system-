-- ============================================================
-- Project Kubera — Financial Operations Database Schema
-- Star schema for NBFC analytics with AI decision engine
-- Rs.18,000 Cr AUM | Rs.2,400 Cr Portfolio | 250 Branches | 1.2M Customers
-- ============================================================

DROP TABLE IF EXISTS fact_loans;
DROP TABLE IF EXISTS fact_collections;
DROP TABLE IF EXISTS fact_ai_decisions;
DROP TABLE IF EXISTS fact_payments;
DROP TABLE IF EXISTS dim_branch;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_agent;

-- ============================================================
-- DIMENSION TABLES
-- ============================================================

CREATE TABLE dim_branch (
    branch_id       SERIAL PRIMARY KEY,
    branch_name     VARCHAR(50) NOT NULL,
    city            VARCHAR(50),
    region          VARCHAR(50),
    state           VARCHAR(50),
    total_employees INT,
    status          VARCHAR(20) CHECK (status IN ('Active', 'Under Review', 'Closure Recommended')),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_product (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(50) NOT NULL,
    product_type    VARCHAR(30) CHECK (product_type IN ('Home Loan', 'Gold Loan', 'MSME Loan', 'Vehicle Loan', 'Personal Loan')),
    avg_yield_pct   DECIMAL(5,2),
    avg_ticket_size DECIMAL(12,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_customer (
    customer_id     SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    age             INT,
    gender          VARCHAR(10),
    occupation      VARCHAR(50),
    income_monthly  DECIMAL(12,2),
    cibil_score     INT,
    segment         VARCHAR(30) CHECK (segment IN ('Affluent Savers', 'Young Professionals', 'MSME Owners', 'Agricultural', 'First-Time Borrowers', 'At-Risk')),
    digital_pct     DECIMAL(5,2),
    clv             DECIMAL(12,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_agent (
    agent_id        SERIAL PRIMARY KEY,
    agent_name      VARCHAR(100) NOT NULL,
    branch_id       INT REFERENCES dim_branch(branch_id),
    role            VARCHAR(30) CHECK (role IN ('Sales Executive', 'Collections Agent', 'Branch Manager', 'Credit Analyst')),
    performance_score DECIMAL(3,1),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- FACT TABLES
-- ============================================================

CREATE TABLE fact_loans (
    loan_id         SERIAL PRIMARY KEY,
    customer_id     INT REFERENCES dim_customer(customer_id),
    branch_id       INT REFERENCES dim_branch(branch_id),
    product_id      INT REFERENCES dim_product(product_id),
    loan_amount     DECIMAL(12,2),
    sanctioned_amount DECIMAL(12,2),
    disbursed_amount DECIMAL(12,2),
    interest_rate   DECIMAL(5,2),
    tenure_months   INT,
    application_date DATE,
    sanction_date   DATE,
    disbursement_date DATE,
    status          VARCHAR(20) CHECK (status IN ('Applied', 'Sanctioned', 'Disbursed', 'Closed', 'NPA')),
    npa_date        DATE,
    ai_approved     BOOLEAN,
    ai_confidence   DECIMAL(5,2),
    human_override  BOOLEAN DEFAULT FALSE,
    override_reason TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fact_collections (
    collection_id   SERIAL PRIMARY KEY,
    loan_id         INT REFERENCES fact_loans(loan_id),
    agent_id        INT REFERENCES dim_agent(agent_id),
    bucket          VARCHAR(20) CHECK (bucket IN ('1-30', '31-60', '61-90', '91-180', '180+')),
    overdue_amount  DECIMAL(12,2),
    days_overdue    INT,
    ai_recovery_prob DECIMAL(5,2),
    ai_recommendation VARCHAR(100),
    recovery_amount DECIMAL(12,2),
    visit_date      DATE,
    customer_rating DECIMAL(2,1),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fact_ai_decisions (
    decision_id     SERIAL PRIMARY KEY,
    loan_id         INT REFERENCES fact_loans(loan_id),
    customer_id     INT REFERENCES dim_customer(customer_id),
    ai_decision     VARCHAR(20) CHECK (ai_decision IN ('Approve', 'Reject', 'Conditional')),
    ai_confidence   DECIMAL(5,2),
    risk_score      DECIMAL(5,2),
    feature_importance JSONB,
    human_decision  VARCHAR(20),
    human_override  BOOLEAN DEFAULT FALSE,
    override_reason TEXT,
    outcome_status  VARCHAR(20),
    decision_date   DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fact_payments (
    payment_id      SERIAL PRIMARY KEY,
    branch_id       INT REFERENCES dim_branch(branch_id),
    product_id      INT REFERENCES dim_product(product_id),
    payment_type    VARCHAR(30) CHECK (payment_type IN ('Interest Income', 'Fee Income', 'Other Income', 'Interest Expense', 'Operating Expense', 'Provision', 'Tax')),
    amount          DECIMAL(12,2),
    payment_date    DATE,
    quarter         VARCHAR(10),
    fy_year         VARCHAR(10),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO dim_branch (branch_name, city, region, state, total_employees, status) VALUES
('Begumpet HQ', 'Hyderabad', 'Hyderabad Metro', 'Telangana', 45, 'Active'),
('Ameerpet', 'Hyderabad', 'Hyderabad Metro', 'Telangana', 38, 'Active'),
('LB Nagar', 'Hyderabad', 'Hyderabad Metro', 'Telangana', 35, 'Active'),
('Kukatpally', 'Hyderabad', 'Hyderabad Metro', 'Telangana', 32, 'Active'),
('Madhapur', 'Hyderabad', 'Hyderabad Metro', 'Telangana', 28, 'Active'),
('Nellore Rural', 'Nellore', 'AP Coastal', 'Andhra Pradesh', 12, 'Under Review'),
('Karimnagar East', 'Karimnagar', 'Telangana Rural', 'Telangana', 10, 'Under Review'),
('Coimbatore South', 'Coimbatore', 'Tamil Nadu', 'Tamil Nadu', 14, 'Closure Recommended'),
('Warangal Old City', 'Warangal', 'Telangana Rural', 'Telangana', 11, 'Under Review'),
('Khammam Rural', 'Khammam', 'Telangana Rural', 'Telangana', 9, 'Closure Recommended');

INSERT INTO dim_product (product_name, product_type, avg_yield_pct, avg_ticket_size) VALUES
('Home Loan', 'Home Loan', 8.5, 2800000.00),
('Gold Loan', 'Gold Loan', 12.2, 120000.00),
('MSME Working Capital', 'MSME Loan', 11.8, 800000.00),
('Vehicle Loan', 'Vehicle Loan', 10.5, 450000.00),
('Personal Loan', 'Personal Loan', 14.5, 280000.00);

INSERT INTO dim_customer (customer_name, age, gender, occupation, income_monthly, cibil_score, segment, digital_pct, clv) VALUES
('Mr. Ramesh Gupta', 42, 'Male', 'IT Professional', 180000.00, 780, 'Young Professionals', 89, 380000.00),
('Mrs. Lakshmi Devi', 55, 'Female', 'Business Owner', 85000.00, 720, 'MSME Owners', 45, 620000.00),
('Mr. Arjun Nair', 38, 'Male', 'Retail Shop Owner', 45000.00, 680, 'MSME Owners', 62, 210000.00),
('Mr. Suresh Nair', 34, 'Male', 'Factory Worker', 28000.00, 620, 'First-Time Borrowers', 34, 150000.00),
('Mrs. Priya Sharma', 41, 'Female', 'Bank Manager', 120000.00, 820, 'Affluent Savers', 91, 1250000.00),
('Mr. Rajesh Kumar', 29, 'Male', 'Self-Employed', 45000.00, 710, 'First-Time Borrowers', 78, 180000.00);

INSERT INTO dim_agent (agent_name, branch_id, role, performance_score) VALUES
('Rajesh Kumar', 1, 'Collections Agent', 8.2),
('Priya Sharma', 2, 'Collections Agent', 7.8),
('Vikram Reddy', 3, 'Collections Agent', 6.2),
('Anita Gupta', 4, 'Collections Agent', 4.8),
('Suresh Nair', 5, 'Collections Agent', 5.8);

INSERT INTO fact_loans (customer_id, branch_id, product_id, loan_amount, sanctioned_amount, disbursed_amount, interest_rate, tenure_months, application_date, sanction_date, disbursement_date, status, ai_approved, ai_confidence, human_override, override_reason) VALUES
(5, 1, 1, 1500000.00, 1500000.00, 1500000.00, 8.5, 240, '2026-06-01', '2026-06-05', '2026-06-10', 'Disbursed', TRUE, 96.0, FALSE, NULL),
(2, 3, 2, 800000.00, 800000.00, 800000.00, 12.2, 12, '2026-05-15', '2026-05-18', '2026-05-20', 'Disbursed', TRUE, 91.0, FALSE, NULL),
(3, 7, 3, 500000.00, 500000.00, 0.00, 11.8, 36, '2026-06-10', '2026-06-12', NULL, 'Sanctioned', FALSE, 72.0, FALSE, NULL),
(4, 8, 5, 400000.00, 0.00, 0.00, 14.5, 24, '2026-06-20', NULL, NULL, 'Applied', FALSE, 78.0, TRUE, 'Branch manager vouched for applicant'),
(6, 5, 4, 600000.00, 600000.00, 0.00, 10.5, 60, '2026-06-25', '2026-06-28', NULL, 'Sanctioned', TRUE, 88.0, FALSE, NULL);

INSERT INTO fact_collections (loan_id, agent_id, bucket, overdue_amount, days_overdue, ai_recovery_prob, ai_recommendation, recovery_amount, visit_date, customer_rating) VALUES
(2, 1, '61-90', 420000.00, 67, 82.0, 'Offer 1-time settlement at 90%', 0.00, '2026-07-10', 4.2),
(3, 3, '91-180', 850000.00, 124, 34.0, 'Initiate SARFAESI proceedings', 0.00, '2026-07-08', 2.8);

INSERT INTO fact_ai_decisions (loan_id, customer_id, ai_decision, ai_confidence, risk_score, human_decision, human_override, override_reason, outcome_status, decision_date) VALUES
(4, 4, 'Reject', 89.0, 78.0, 'Approve', TRUE, 'Branch manager vouched for applicant. New employment since 2022.', 'On track', '2026-07-09'),
(1, 5, 'Approve', 96.0, 12.0, 'Approve', FALSE, NULL, 'On track', '2026-07-08'),
(3, 3, 'Conditional', 71.0, 45.0, 'Send Conditional', FALSE, NULL, 'Pending', '2026-07-07'),
(5, 6, 'Approve', 88.0, 28.0, 'Approve', FALSE, NULL, 'On track', '2026-07-06');

INSERT INTO fact_payments (branch_id, product_id, payment_type, amount, payment_date, quarter, fy_year) VALUES
(1, 1, 'Interest Income', 98000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, 2, 'Interest Income', 42000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, 3, 'Interest Income', 32000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Fee Income', 28000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Other Income', 8000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Interest Expense', 88000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Operating Expense', 42000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Provision', 18000000.00, '2026-07-01', 'Q2', 'FY2026'),
(1, NULL, 'Tax', 12000000.00, '2026-07-01', 'Q2', 'FY2026');
