# Project Kubera — Financial Operations & Decision Intelligence Platform

> **Senior PM/PO Portfolio Piece** | AI-Assisted Financial Services Dashboard  
> **Real Data Model:** Rs.18,000 Cr AUM | Rs.2,400 Cr Loan Portfolio | 250 Branches | 4,000 Employees | 1.2M Customers  
> **Built by:** Guptha Ashish Goud

---

## Problem Statement

A mid-size NBFC (Non-Banking Financial Company) in India was managing Rs.18,000 Cr AUM across 250 branches but faced:

- **No CEO-level morning dashboard** — leadership started days with 20 phone calls, not data
- **Opaque AI decisions** — credit risk model rejected applicants with no explanation, eroding trust
- **Siloed operations** — Sales, Risk, Collections, Finance, Compliance each used different systems
- **Reactive collections** — agents visited random accounts instead of AI-prioritized high-recovery cases
- **No strategic scenario planning** — board presentations took 2 weeks to prepare
- **Regulatory compliance gaps** — RBI observations for delayed NPA classification

## Solution

An **8-tab persona-driven analytics dashboard** with explainable AI and human-in-the-loop decision making:

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

## Unique Differentiators

1. **Explainable AI** — Every rejection shows "Why AI Rejected" with feature-level reasoning
2. **Human Override Logging** — 4.8% override rate, all logged for model learning
3. **Strategic What-If** — RBI rate cut, NPA stress, digital-only branch scenarios
4. **Bias Audit** — Demographic parity (0.02) and equal opportunity (0.03) scores visible
5. **AI Recovery Scoring** — Collections agents prioritize by recovery probability, not random

## Tech Stack

- **Frontend:** Vanilla HTML/CSS/JS (widget-ready, zero dependencies)
- **Data Model:** Star schema (see `data/kubera_schema.sql`)
- **Analytics:** 5 SQL queries covering portfolio, risk, collections, P&L, compliance
- **API:** OpenAPI 3.0 spec with JWT auth (see `api/kubera_api_spec.yaml`)
- **Automation:** n8n flows for AI decision logging + collections prioritization
- **ML:** Python scikit-learn model (see `ml/credit_risk_model.py`)
- **Design:** Dark-theme MNC standard (black header, centered KPIs, top accent bars)

## Business Impact

| Metric | Before | After (Projected) |
|---|---|---|
| CEO morning prep time | 90 min (calls) | 5 min (dashboard) |
| Credit decision time | 5-7 days | 4.2 days |
| Collections efficiency | 87% | 94.6% |
| AI model trust (override rate) | 12% | 4.8% |
| Board report prep time | 2 weeks | 2 hours |
| NPA classification delay | 15 days | 0 days (auto) |

## Repository Structure

```
project-kubera/
├── README.md                          # This file
├── dashboard/
│   └── Project_Kubera_MNC_Widget.html  # Locked cosmetics, all original data
├── data/
│   └── kubera_schema.sql              # Star schema + sample data
├── analytics/
│   └── kubera_queries.sql             # 5 business queries with sample outputs
├── automation/
│   ├── ai_decision_logger.json        # n8n flow — log every AI decision + override
│   └── collections_prioritizer.json   # n8n flow — auto-prioritize collections by AI score
├── api/
│   └── kubera_api_spec.yaml           # OpenAPI 3.0 — 8 endpoints, JWT auth
├── ml/
│   └── credit_risk_model.py           # Python scikit-learn model spec
├── design/
│   └── wireframes.figjam.md           # 8 persona journeys + component library
└── project/
    └── sprint_board.md                # 64 stories, 4 sprints, risk register
```

## How to Run

1. Open `dashboard/Project_Kubera_MNC_Widget.html` in any modern browser
2. No build step required — pure HTML/CSS/JS
3. For backend integration, reference `api/kubera_api_spec.yaml`
4. For ML model, reference `ml/credit_risk_model.py`

## License

Portfolio demonstration. All data is modeled on real NBFC operations, fully anonymized.

---

*"Where AI explains, humans decide, and trust compounds."*  
— Guptha Ashish Goud
