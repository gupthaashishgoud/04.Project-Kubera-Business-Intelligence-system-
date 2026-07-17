# Project Kubera — AI/ML Model Cards

> **Model Governance:** Explainable AI | Bias Audited | Human-in-the-Loop | Weekly Retraining  
> **Last Updated:** 11 July 2026 | **Next Retraining:** 18 July 2026

---

## Model 1: Credit Risk Scoring Model

### Purpose
Predict probability of loan default for new applications. Powers AI decision engine (Act 4).

### Architecture
- **Algorithm:** Gradient Boosting (XGBoost v1.7)
- **Features:** 47 features (CIBIL, income, employment, debt-to-income, existing relationships, etc.)
- **Training Data:** 850K historical loans (2019-2026)
- **Validation:** 5-fold cross-validation, temporal split

### Performance
| Metric | Value | Target |
|---|---|---|
| AUC-ROC | 94.2% | >92% |
| Precision | 91.5% | >88% |
| Recall | 89.8% | >85% |
| False Positive Rate | 2.8% | <4% |
| False Negative Rate | 3.1% | <5% |

### Explainability
- **SHAP values** for every prediction
- **Feature importance:** CIBIL (28%), Income (19%), DTI (15%), Employment (12%)
- **Decision reason** auto-generated: "CIBIL excellent + stable employment + collateral value 2.5x loan"

### Bias Audit
| Metric | Score | Threshold | Status |
|---|---|---|---|
| Demographic Parity (Gender) | 0.02 | <0.05 | Pass |
| Equal Opportunity (Region) | 0.03 | <0.05 | Pass |
| Calibration by Segment | 0.98 | >0.95 | Pass |

### Override Tracking
- **Override Rate:** 4.8% of all decisions
- **Override Accuracy:** 78% correct (validated by outcome)
- **Learning Loop:** All overrides feed into weekly retraining

---

## Model 2: Collections Recovery Prediction

### Purpose
Predict probability of recovering overdue amount by bucket. Powers AI recovery recommendations (Act 5).

### Architecture
- **Algorithm:** Random Forest (scikit-learn v1.3)
- **Features:** 32 features (bucket age, collateral value, customer history, prior defaults, etc.)
- **Training Data:** 420K collections cases (2020-2026)

### Performance
| Metric | Value | Target |
|---|---|---|
| Recovery Probability Accuracy | 88.4% | >85% |
| Settlement Acceptance Rate | 72% | >65% |
| Legal Success Prediction | 81% | >75% |

### Recommendations
| Recovery Prob | Action | Expected Recovery |
|---|---|---|
| >70% | Settlement offer (85-95% principal) | 82% avg |
| 50-70% | Field visit + negotiation | 58% avg |
| <50% | Legal proceedings (SARFAESI) | 28% avg |

---

## Model 3: Cross-Sell Recommendation Engine

### Purpose
Predict next best product for existing customers. Powers cross-sell triggers (Act 3).

### Architecture
- **Algorithm:** Matrix Factorization + Gradient Boosting hybrid
- **Features:** 28 features (product history, transaction patterns, life events, digital behavior)
- **Training Data:** 1.2M customer-product interactions

### Performance
| Metric | Value | Target |
|---|---|---|
| Top-1 Accuracy | 42% | >38% |
| Top-3 Accuracy | 68% | >60% |
| Conversion Lift | 86.2% | >75% |

---

## Model 4: Churn Prediction

### Purpose
Predict customer churn probability 90 days in advance. Powers retention campaigns.

### Architecture
- **Algorithm:** LSTM Neural Network (TensorFlow v2.13)
- **Features:** 35 time-series features (transaction frequency, balance trends, complaint history)
- **Training Data:** 600K customer journeys

### Performance
| Metric | Value | Target |
|---|---|---|
| Recall | 92.6% | >88% |
| Precision | 78.4% | >72% |
| F1 Score | 84.9% | >80% |

---

## Model 5: Lead Scoring

### Purpose
Rank incoming leads by conversion probability. Powers AI lead scoring (Act 2).

### Architecture
- **Algorithm:** Logistic Regression + XGBoost ensemble
- **Features:** 22 features (source, demographics, inquiry type, response time)
- **Training Data:** 2.4M leads

### Performance
| Metric | Value | Target |
|---|---|---|
| Top-Decile Lift | 89.1% | >80% |
| AUC-ROC | 87.3% | >82% |
| Conversion Rate (Top 10%) | 34% | >28% |

---

## Model Governance

### Retraining Schedule
| Model | Frequency | Last Retrained | Next Scheduled |
|---|---|---|---|
| Credit Risk | Weekly | 11 July 2026 | 18 July 2026 |
| Collections | Bi-weekly | 8 July 2026 | 22 July 2026 |
| Cross-sell | Monthly | 1 July 2026 | 1 Aug 2026 |
| Churn | Weekly | 11 July 2026 | 18 July 2026 |
| Lead Scoring | Weekly | 11 July 2026 | 18 July 2026 |

### Data Drift Monitoring
| Feature | Drift Score | Threshold | Status |
|---|---|---|---|
| IT sector employment % | 0.08 | 0.05 | Alert |
| Agricultural rainfall index | 0.06 | 0.05 | Alert |
| All other features | <0.03 | 0.05 | OK |

**Action:** Manual review of Chennai home loan approvals until retraining complete (18 July).

### Regulatory Compliance
- [x] RBI guidelines on AI/ML in lending (Circular RBI/2023-24/42)
- [x] Explainability requirements met (SHAP + reason codes)
- [x] Bias audit completed quarterly
- [x] Human override capability maintained
- [x] Audit trail for all decisions (100%)

---

*Model cards updated per MLOps best practices.*  
*All models versioned in MLflow. All experiments tracked in Weights & Biases.*
