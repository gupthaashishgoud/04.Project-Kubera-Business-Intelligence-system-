# Project Kubera — AI-Assisted Financial Operations & Decision Intelligence Platform

> **Power BI + Python ML Business Intelligence Project** | SQL · DAX · scikit-learn · OpenAPI · n8n  
> **Data Model:** ₹18,000 Cr AUM | ₹2,400 Cr Loan Portfolio | 250 Branches | 4,000 Employees | 1.2M Customers  
> **Built by:** Guptha Ashish Goud

---

## Overview

An AI-assisted financial operations platform for a mid-size NBFC (Non-Banking Financial Company) in India managing ₹18,000 Cr AUM across 250 branches. The system features an explainable AI credit risk model, human-in-the-loop decision logging, AI-prioritized collections, RBI regulatory compliance tracking, and strategic scenario planning — all delivered through an 8-persona dashboard.

This is the project most directly relevant to compliance and risk roles: it demonstrates AI-driven credit decisioning, regulatory compliance frameworks (RBI, KYC/AML), explainable AI with bias auditing, and audit-ready decision logging.

## Problem

A mid-size NBFC managing ₹18,000 Cr AUM across 250 branches faced:

- No CEO-level morning dashboard — leadership started days with 20 phone calls, not data
- Opaque AI decisions — credit risk model rejected applicants with no explanation, eroding trust
- Siloed operations — Sales, Risk, Collections, Finance, Compliance each used different systems
- Reactive collections — agents visited random accounts instead of AI-prioritized high-recovery cases
- Regulatory compliance gaps — RBI observations for delayed NPA classification
- No strategic scenario planning — board presentations took 2 weeks to prepare

## Solution

An 8-tab persona-driven analytics dashboard with explainable AI and human-in-the-loop decision making:

| Act | Persona | Key Features |
|---|---|---|
| Act 1 | CEO | Morning dashboard, executive action queue, portfolio mix, branch heatmap |
| Act 2 | COO | Sales pipeline, AI lead scoring, regional performance, product conversion |
| Act 3 | Customer Head | Journey funnel, drop-off analysis, cross-sell triggers, segment intelligence |
| Act 4 | CRO | AI decision engine, explainable rejections, risk heatmap, bias audit |
| Act 5 | Collections Mgr | Bucket aging, AI recovery recommendations, field agent tracking |
| Act 6 | CFO | P&L waterfall, product profitability, branch profitability ranking |
| Act 7 | CCO | RBI compliance, KYC/AML, audit findings, grievance tracker |
| Act 8 | Executive | Strategic scenarios, model performance, decision log, board insights |

## Key Results

| Metric | Before | After | Improvement |
|---|---|---|---|
| CEO morning prep time | 90 min (calls) | 5 min (dashboard) | -94% |
| Credit decision time | 5-7 days | 4.2 days | -37% |
| Collections efficiency | 87% | 94.6% | +8.7% |
| AI model trust (override rate) | 12% | 4.8% | -60% |
| Board report prep time | 2 weeks | 2 hours | -93% |
| NPA classification delay | 15 days | 0 days (auto) | Eliminated |

## AI & Compliance Highlights

1. **Explainable AI** — Every credit rejection shows "Why AI Rejected" with feature-level reasoning, enabling human review and regulatory transparency
2. **Human Override Logging** — 4.8% override rate, all decisions logged for model learning and audit trails
3. **Bias Audit** — Demographic parity (0.02) and equal opportunity (0.03) scores visible on the CRO dashboard
4. **RBI Compliance Tab** — Dedicated CCO dashboard tracking KYC/AML, audit findings, NPA classification, and grievance management
5. **AI Recovery Scoring** — Collections agents prioritize by AI-predicted recovery probability, not random visits
6. **Strategic What-If Scenarios** — RBI rate cut, NPA stress test, digital-only branch scenarios for board-level planning

## Tech Stack

- **Frontend:** Vanilla HTML/CSS/JS (widget-ready, zero dependencies)
- **Data Model:** Star schema in SQL Server (see `data/kubera_schema.sql`)
- **Analytics:** 5 SQL queries covering portfolio, risk, collections, P&L, compliance
- **ML:** Python scikit-learn credit risk model (see `ml/credit_risk_model.py`)
- **API:** OpenAPI 3.0 spec with JWT auth (see `api/kubera_api_spec.yaml`)
- **Automation:** n8n flows for AI decision logging + collections prioritization
- **Design:** Dark-theme MNC-grade UI standard

## Repository Structure

```
├── dashboard/          # Interactive HTML dashboard widget (8 personas)
├── data/               # SQL Server star schema + sample data
├── analytics/          # 5 business SQL queries with sample outputs
├── automation/          # AI decision logger + collections prioritizer flows
├── api/                 # OpenAPI 3.0 spec — 8 endpoints, JWT auth
├── ml/                  # Python scikit-learn credit risk model + model cards
├── design/              # Persona wireframes and journey maps
└── project/             # Sprint board: 64 stories, 4 sprints, risk register
```

## How to Run

1. Open `dashboard/Project_Kubera_MNC_Widget.html` in any modern browser
2. No build step required — pure HTML/CSS/JS
3. For SQL queries, load `data/kubera_schema.sql` into SQL Server
4. For ML model, run `ml/credit_risk_model.py` with Python 3.10+ and scikit-learn
5. For API integration, reference `api/kubera_api_spec.yaml`

## Relevance to Compliance & Risk Roles

This project demonstrates hands-on experience with:
- **AI-driven credit risk assessment** — model with explainable rejections and feature-level reasoning
- **Regulatory compliance** — RBI compliance dashboard, NPA classification automation, KYC/AML tracking
- **Audit-ready decision logging** — every AI decision and human override logged for regulatory review
- **AI bias auditing** — demographic parity and equal opportunity scoring for fair lending compliance
- **Risk management** — portfolio risk heatmaps, NPA stress testing, scenario planning
- **Financial crime prevention** — KYC/AML integration, suspicious activity monitoring framework

---

*Portfolio demonstration. All data is modeled on real NBFC operations, fully anonymized.*  
*Built by Guptha Ashish Goud — Compliance & Risk Analyst | Data-Driven Decision Making | AI & Automation*
