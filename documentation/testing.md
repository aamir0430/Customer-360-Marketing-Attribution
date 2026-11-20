# Testing and Validation Documentation

## 1. Overview

Testing was performed throughout the Customer 360 & Marketing Attribution implementation to validate data quality, identity resolution, transformation logic, attribution outputs and campaign efficiency calculations.

## 2. dbt Testing

The project uses dbt schema tests and singular tests.

Recorded results:

| Test Category | Passed |
|---|---:|
| Schema Tests | 21 |
| Singular Tests | 5 |

## 3. Data Quality Validation

The final recorded data-quality validation query returned zero exception rows.

This indicates that the records checked by that query satisfied its defined validation conditions.

## 4. Identity Resolution Testing

Identity resolution was validated using the available website identifiers and synthetic CRM mapping records.

Recorded outputs:

- 360,129 GA4 sessions.
- 10,246 identified customers.
- 349,883 unidentified sessions.

The implementation retains unmatched sessions.

## 5. Attribution Testing

The project validates four attribution approaches:

- First-Touch.
- Last-Touch.
- Linear.
- Time-Decay.

Recorded reconciliation:

- 4,452 attribution credits/records.
- $307,868 attributed revenue per attribution model.

The attribution models are alternative credit-allocation methods applied to the same underlying conversion/revenue scope.

## 6. Campaign Efficiency Testing

The project uses:

`fct_campaign_efficiency`

and

`fct_channel_roi`

Recorded input scope:

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Advertising Records | 736 |
| Advertising Spend | $126,552.23 |
| Simulated Conversions | 6,231 |

## 7. Channel ROI Validation

The channel ROI implementation was tested using 10 validation records.

| Check | Result |
|---|---:|
| Total Validation Records | 10 |
| Passed | 10 |
| Failed | 0 |
| Advertising Spend Difference | $0.00 |

The spend reconciliation difference was zero.

This validates the tested spend reconciliation logic within the supplied dataset. It does not independently verify advertising conversion accuracy or live campaign ROI.

## 8. Tableau Validation

The four completed dashboards were reviewed for:

- Data availability.
- KPI presentation.
- Visual consistency.
- Dashboard filtering.
- Attribution comparison.
- Campaign performance reporting.
- Marketing efficiency reporting.

## 9. Known Testing Limitations

The following limitations remain:

1. Advertising conversion inputs are simulated.
2. Six source/medium combinations remain unmapped.
3. Google Brand and Generic campaign performance cannot be reliably separated.
4. Complete campaign-level ROAS and CPA are unavailable.
5. Profit-based and incremental ROI are not established.

## 10. Final Testing Conclusion

The recorded dbt and analytical validation results support the implementation of the project's analytical workflow.

However, the results must be interpreted within the scope of the public GA4 sample data, synthetic CRM and advertising inputs, and incomplete campaign mapping.