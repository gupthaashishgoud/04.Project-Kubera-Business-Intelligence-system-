# Project Kubera — UX Design Documentation

> **Design System:** Dark-theme MNC-grade restraint | Black header | White text | Green=Positive, Red=Negative, Amber=Brand  
> **Cosmetic Standard:** Locked from Devil's Den v2.0 (adapted for dark theme)

---

## 1. Persona Journey Map

### Persona 1: CEO (Act 1 — Morning Dashboard)
**Goal:** Start the day with "What happened? Why? What action? What impact?"

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | Open dashboard at 8AM | Black header loads with gold Kubera logo | Static config |
| 2 | View 4 KPIs | Centered cards: AUM, Portfolio, NPA, Collections | `fact_loans` + `fact_payments` |
| 3 | Read action queue | 3 alert cards (High/Med/Low) with AI recommendations | Real-time triggers |
| 4 | Review portfolio mix | 5-bar chart (Home/Gold/MSME/Vehicle/Personal) | `dim_product` |
| 5 | Scan branch heatmap | 250-row table, Top 10 + Bottom 10 | `dim_branch` + `fact_loans` |

**Pain Point Solved:** "I used to make 20 phone calls before 9AM. Now I drink my coffee and read the dashboard."

---

### Persona 2: COO (Act 2 — Sales Command)
**Goal:** Track pipeline, conversion, and AI lead scoring across 250 branches.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View disbursal KPIs | 4 centered cards (Disbursal, Leads, Conversion, Approval Time) | `fact_loans` |
| 2 | Review product pipeline | 5-row table with conversion rates | `fact_loans` GROUP BY product |
| 3 | Check AI lead scoring | 3 AI recommendation cards with confidence scores | ML model API |
| 4 | Scan regional performance | 8-row table with gap analysis | `dim_branch` + region aggregate |

**Pain Point Solved:** "Sales used to chase cold leads. Now AI tells them exactly who to call first."

---

### Persona 3: Customer Head (Act 3 — Journey Intelligence)
**Goal:** Reduce drop-offs, increase cross-sell, improve NPS.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View customer KPIs | 4 centered cards (Base, CLV, NPS, Cross-sell) | `dim_customer` |
| 2 | Review journey funnel | 4 metric boxes + 5-bar drop-off chart | `fact_loans` stage tracking |
| 3 | Check drop-off hotspots | 3 alert cards with AI root cause | Funnel analytics |
| 4 | Review segment intelligence | 6-row table with next-best-action | `dim_customer` segmentation |

**Pain Point Solved:** "We used to lose 20% of customers at KYC. Now we know exactly why and fixed it."

---

### Persona 4: CRO (Act 4 — Credit Risk & AI)
**Goal:** Manage portfolio risk with explainable AI and human oversight.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View risk KPIs | 4 centered cards (NPA, Exposure, AI Rate, Override Rate) | `fact_loans` + `fact_ai_decisions` |
| 2 | Review AI decisions | 3 live cases (Reject/Approve/Conditional) with explanations | `fact_ai_decisions` |
| 3 | Check risk heatmap | 8x5 matrix (Region x Product NPA%) | `fact_loans` pivot |
| 4 | Audit model bias | 6 metric boxes (Accuracy, FPR, FNR, Demographic Parity, etc.) | ML model metrics |

**Pain Point Solved:** "We used to reject applicants with no explanation. Now every decision is explainable and auditable."

---

### Persona 5: Collections Manager (Act 5 — Collections)
**Goal:** Maximize recovery while maintaining customer relationships.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View collections KPIs | 4 centered cards (Efficiency, Overdue, Recovery, Write-offs) | `fact_collections` |
| 2 | Review bucket aging | 5-row table with strategy per bucket | `fact_collections` |
| 3 | Check AI recommendations | 2 recovery cards with probability scores | ML recovery model |
| 4 | Track field agents | 5-row performance table | `fact_collections` + `dim_agent` |

**Pain Point Solved:** "Agents used to visit random accounts. Now AI tells them which accounts have 82% recovery probability."

---

### Persona 6: CFO (Act 6 — Portfolio Health)
**Goal:** Track P&L, product profitability, and branch-level margins.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View profitability KPIs | 4 centered cards (Yield, Cost Ratio, COF, NIM) | `fact_payments` |
| 2 | Review P&L waterfall | Revenue → Costs → Net Profit bars | `fact_payments` |
| 3 | Check product P&L | 5-row table with NIM and net margin | `fact_payments` JOIN `dim_product` |
| 4 | Rank branch profitability | 250-row table, Top 5 + Bottom 5 | `fact_payments` per branch |

**Pain Point Solved:** "I used to find branch profitability in 4 different systems. Now it's one table."

---

### Persona 7: CCO (Act 7 — Compliance)
**Goal:** Ensure RBI compliance, KYC/AML, and grievance resolution.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View compliance KPIs | 4 centered cards (RBI, KYC, AML, Audit) | Compliance register |
| 2 | Check compliance matrix | 8 metric boxes (Registration, KYC, Fair Practice, etc.) | Compliance checks |
| 3 | Review open findings | 3 alert cards (Cash gap, NPA delay, AML flags) | Audit reports |
| 4 | Track grievances | 6-row table with TAT per category | Grievance system |

**Pain Point Solved:** "RBI observations used to surprise us. Now we see them coming 30 days early."

---

### Persona 8: Executive (Act 8 — AI Strategy)
**Goal:** Board-ready insights, strategic scenarios, model governance.

| Step | Action | UI Element | Data Source |
|---|---|---|---|
| 1 | View AI KPIs | 4 centered cards (Uptime, Automation, Retraining, Drift) | ML ops |
| 2 | Run what-if scenarios | 3 scenario cards (Rate cut, NPA rise, Digital branch) | Financial model |
| 3 | Check model performance | 6 metric boxes (Credit, Collections, Fraud, Cross-sell, Churn, Lead) | ML metrics |
| 4 | Review decision log | 6-row table (AI rec vs Human action vs Outcome) | `fact_ai_decisions` |

**Pain Point Solved:** "Board presentations used to take 2 weeks. Now I generate them in 2 hours."

---

## 2. Component Library

### KPI Card (Centered, Top Accent — Dark Theme)
```
┌─────────────────────────┐
│ ▓▓▓▓ (4px top border)   │  ← Green/Amber/Red/Blue/Purple
│                         │
│           AUM           │  ← Label: uppercase, 0.7rem, grey
│                         │
│      Rs.18,042 Cr       │  ← Value: 1.4rem, bold, white
│                         │
│      +0.8% vs yesterday │  ← Delta: 0.72rem, grey, centered
│                         │
└─────────────────────────┘
  background: rgba(255,255,255,0.04)
  border: 1px solid rgba(255,255,255,0.06)
  min-height: 110px
  padding: 20px 16px
  align-items: center
  justify-content: center
  text-align: center
```

### Alert Card (Top Accent, Centered Text — Dark Theme)
```
┌─────────────────────────┐
│ ▓▓▓▓ (4px top, red)     │
│                         │
│         HIGH            │
│                         │
│   Home Loan NPA Spiking │
│   in South Region       │
│   NPA jumped from 1.8%  │
│   to 2.9% in 30 days... │
│                         │
│      [ Brief CRO ]      │
└─────────────────────────┘
  background: gradient from tinted top to base
  padding: 20px
  text-align: center
```

### AI Recommendation Card (Dark Theme)
```
┌─────────────────────────┐
│ Lead #HL-28471 — 94/100 │
│ Mr. Ramesh Gupta, 42    │
│ IT Professional, Hyd    │
│ CIBIL 780, Rs.1.8L/mo   │
│ ─────────────────────── │
│ Why: High CIBIL +       │
│ existing relationship + │
│ stable employment       │
│ [Assign & Notify] [Ovrd]│
└─────────────────────────┘
  background: gradient amber/purple tint
  border: 1px solid rgba(245,158,11,0.15)
```

### Bar Chart (Soulful Colors — Dark Theme)
```
Home Loans    ████████████████████░░░░░  Rs.918 Cr  ← #4A6741 (deep forest)
Gold Loans    ████████████░░░░░░░░░░░░░  Rs.580 Cr  ← #8B7355 (warm brown)
MSME Loans    █████████░░░░░░░░░░░░░░░░  Rs.435 Cr  ← #5B8A72 (sage)
Vehicle Loans ██████░░░░░░░░░░░░░░░░░░░  Rs.290 Cr  ← #6B5B95 (muted purple)
Personal Loans████░░░░░░░░░░░░░░░░░░░░░░░  Rs.195 Cr  ← #8B4557 (muted rose)
```

---

## 3. Color Palette (Locked — Dark Theme)

| Token | Hex | Usage |
|---|---|---|
| `--header-bg` | `#111111` | Hero header background |
| `--header-text` | `#f8fafc` | Hero title |
| `--header-sub` | `#94a3b8` | Hero subtitle |
| `--kpi-green` | `#22c55e` | Positive KPI, approve, on-track |
| `--kpi-amber` | `#f59e0b` | Warning KPI, conditional, watch |
| `--kpi-red` | `#ef4444` | Negative KPI, reject, critical |
| `--kpi-blue` | `#3b82f6` | Neutral KPI, active, info |
| `--kpi-purple` | `#a855f7` | Sales/AI KPI, pipeline, model metrics |
| `--bar-home` | `#4A6741` | Home loan bars (deep forest) |
| `--bar-gold` | `#8B7355` | Gold loan bars (warm brown) |
| `--bar-msme` | `#5B8A72` | MSME bars (sage green) |
| `--bar-vehicle` | `#6B5B95` | Vehicle bars (muted purple) |
| `--bar-personal` | `#8B4557` | Personal loan bars (muted rose) |
| `--bg-page` | `#0a0e1a` | Page background |
| `--bg-card` | `rgba(255,255,255,0.04)` | Card background |
| `--border-card` | `rgba(255,255,255,0.06)` | Card border |
| `--text-primary` | `#f8fafc` | Headings, values |
| `--text-secondary` | `#94a3b8` | Labels, meta, body |
| `--text-muted` | `#64748b` | Delta, captions |

---

## 4. Responsive Breakpoints

| Breakpoint | Grid | Behavior |
|---|---|---|
| >900px | 4-col KPI, 2-col cards, 4-col metrics | Full layout |
| 600-900px | 2-col KPI, 1-col cards, 2-col metrics | Tablet |
| <600px | 1-col everything | Mobile stack |

---

## 5. Accessibility Checklist

- [x] All text meets WCAG AA contrast (4.5:1) against dark backgrounds
- [x] Interactive elements have focus states with amber outline
- [x] Color is not the only indicator (pills have text labels)
- [x] Tables have semantic `<th>` headers
- [x] Buttons have descriptive labels
- [x] AI explanations use simple language (Grade 6 reading level)
- [x] Override reasons are mandatory (no blank overrides)

---

*Design locked per Devil's Den v2.0 cosmetic standard (dark theme adaptation).*  
*No data changes. No analytics changes. Only styling.*
