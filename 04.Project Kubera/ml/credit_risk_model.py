# ============================================================
# Project Kubera — Credit Risk Model Specification
# scikit-learn based model for AI decision engine
# Features: CIBIL, DTI, employment stability, collateral, existing relationship
# ============================================================

import pandas as pd
import numpy as np
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, classification_report, confusion_matrix
import joblib
import json
from datetime import datetime

class KuberaCreditRiskModel:
    """
    Credit Risk Model for NBFC loan approvals.

    Target: Predict probability of default (PD) within 12 months
    Output: Approve / Reject / Conditional with confidence score

    Thresholds:
    - Approve: PD < 15%, confidence > 85%
    - Conditional: PD 15-30%, confidence 60-85%
    - Reject: PD > 30% or confidence < 60%
    """

    def __init__(self):
        self.model = GradientBoostingClassifier(
            n_estimators=200,
            max_depth=5,
            learning_rate=0.1,
            subsample=0.8,
            random_state=42
        )
        self.feature_columns = [
            'cibil_score',
            'debt_to_income',
            'employment_stability_years',
            'collateral_coverage_ratio',
            'existing_relationship_flag',
            'income_monthly',
            'loan_amount',
            'product_type_encoded',
            'region_risk_score'
        ]
        self.threshold_approve = 0.15
        self.threshold_reject = 0.30
        self.min_confidence = 0.60

    def preprocess(self, df):
        """Feature engineering and preprocessing."""
        df['debt_to_income'] = df['existing_emi'] / df['income_monthly']
        df['collateral_coverage_ratio'] = df['collateral_value'] / df['loan_amount']
        df['existing_relationship_flag'] = (df['existing_fd'] > 0).astype(int)
        df['product_type_encoded'] = pd.Categorical(df['product_type']).codes
        df['region_risk_score'] = df['region'].map({
            'Hyderabad Metro': 1.0,
            'Karnataka': 1.2,
            'AP Coastal': 1.4,
            'Telangana Rural': 1.8,
            'Maharashtra': 1.6,
            'Tamil Nadu': 2.2,
            'Kerala': 2.5,
            'North India': 1.9
        }).fillna(1.5)
        return df[self.feature_columns]

    def train(self, X, y):
        """Train the model."""
        X_processed = self.preprocess(X)
        X_train, X_val, y_train, y_val = train_test_split(
            X_processed, y, test_size=0.2, random_state=42, stratify=y
        )
        self.model.fit(X_train, y_train)

        # Validation metrics
        y_pred_proba = self.model.predict_proba(X_val)[:, 1]
        auc = roc_auc_score(y_val, y_pred_proba)
        print(f"Validation AUC-ROC: {auc:.4f}")
        print(f"
Classification Report:
{classification_report(y_val, y_pred_proba > 0.5)}")

        # Feature importance
        importance = pd.DataFrame({
            'feature': self.feature_columns,
            'importance': self.model.feature_importances_
        }).sort_values('importance', ascending=False)
        print(f"
Feature Importance:
{importance}")

        return auc

    def predict(self, application):
        """
        Predict loan outcome for a single application.

        Returns:
            dict: {
                'decision': 'Approve' | 'Reject' | 'Conditional',
                'confidence': float,
                'risk_score': float (0-100),
                'pd': float (probability of default),
                'feature_importance': dict,
                'explanation': str
            }
        """
        X = self.preprocess(pd.DataFrame([application]))
        pd_prob = self.model.predict_proba(X)[0, 1]
        risk_score = pd_prob * 100

        # Determine decision
        if pd_prob < self.threshold_approve:
            decision = 'Approve'
            confidence = min(99, 100 - risk_score)
        elif pd_prob > self.threshold_reject:
            decision = 'Reject'
            confidence = min(99, risk_score)
        else:
            decision = 'Conditional'
            confidence = 60 + (0.5 - abs(pd_prob - 0.225)) * 200
            confidence = min(85, max(60, confidence))

        # Feature importance for explanation
        feature_imp = dict(zip(
            self.feature_columns,
            self.model.feature_importances_
        ))
        top_features = sorted(feature_imp.items(), key=lambda x: x[1], reverse=True)[:3]

        explanation = self._generate_explanation(
            decision, pd_prob, application, top_features
        )

        return {
            'decision': decision,
            'confidence': round(confidence, 1),
            'risk_score': round(risk_score, 1),
            'pd': round(pd_prob, 4),
            'feature_importance': dict(top_features),
            'explanation': explanation
        }

    def _generate_explanation(self, decision, pd_prob, app, top_features):
        """Generate human-readable explanation."""
        reasons = []
        if app['cibil_score'] < 650:
            reasons.append(f"CIBIL score {app['cibil_score']} is below threshold (650)")
        if app.get('debt_to_income', 0) > 0.45:
            reasons.append(f"Debt-to-income ratio {app['debt_to_income']:.0%} exceeds 45%")
        if app.get('employment_stability_years', 0) < 2:
            reasons.append(f"Employment stability {app['employment_stability_years']} years is below 2-year minimum")
        if app.get('existing_relationship_flag', 0) == 1:
            reasons.append("Existing customer relationship is a positive signal")
        if app.get('collateral_coverage_ratio', 0) > 2.0:
            reasons.append(f"Collateral coverage {app['collateral_coverage_ratio']:.1f}x provides strong security")

        if decision == 'Reject':
            return f"AI Rejected: {'; '.join(reasons[:3])}. Risk score: {pd_prob*100:.0f}/100 (High)."
        elif decision == 'Approve':
            return f"AI Approved: {'; '.join(reasons[:3])}. Risk score: {pd_prob*100:.0f}/100 (Low)."
        else:
            return f"AI Conditional: {'; '.join(reasons[:3])}. Risk score: {pd_prob*100:.0f}/100 (Medium). Recommend co-applicant or additional collateral."

    def save(self, path='kubera_credit_model.pkl'):
        """Save model to disk."""
        joblib.dump(self.model, path)
        print(f"Model saved to {path}")

    def load(self, path='kubera_credit_model.pkl'):
        """Load model from disk."""
        self.model = joblib.load(path)
        print(f"Model loaded from {path}")


# ============================================================
# BIAS AUDIT
# ============================================================

def demographic_parity(y_pred, sensitive_attr):
    """
    Calculate demographic parity difference.
    Should be < 0.05 for fairness.
    """
    groups = sensitive_attr.unique()
    rates = []
    for g in groups:
        mask = sensitive_attr == g
        rates.append(y_pred[mask].mean())
    return max(rates) - min(rates)

def equal_opportunity(y_true, y_pred, sensitive_attr):
    """
    Calculate equal opportunity difference (TPR parity).
    Should be < 0.05 for fairness.
    """
    groups = sensitive_attr.unique()
    tprs = []
    for g in groups:
        mask = (sensitive_attr == g) & (y_true == 1)
        if mask.sum() > 0:
            tprs.append(y_pred[mask].mean())
    return max(tprs) - min(tprs) if tprs else 0


# ============================================================
# USAGE EXAMPLE
# ============================================================

if __name__ == '__main__':
    # Initialize model
    model = KuberaCreditRiskModel()

    # Example application
    application = {
        'cibil_score': 780,
        'income_monthly': 180000,
        'existing_emi': 20000,
        'employment_stability_years': 12,
        'collateral_value': 4500000,
        'loan_amount': 1500000,
        'existing_fd': 1500000,
        'product_type': 'Home Loan',
        'region': 'Hyderabad Metro'
    }

    # In production, model would be loaded:
    # model.load('kubera_credit_model.pkl')

    # For demo, show structure:
    print("Kubera Credit Risk Model initialized.")
    print(f"Feature columns: {model.feature_columns}")
    print(f"Thresholds — Approve: <{model.threshold_approve}, Reject: >{model.threshold_reject}")
