from pathlib import Path
import numpy as np
import pandas as pd

SEED = 42
ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
RAW.mkdir(parents=True, exist_ok=True)
rng = np.random.default_rng(SEED)
dates = pd.date_range("2020-11-01", "2021-01-31", freq="D")

campaigns = [
("CMP001","Google Search - Brand","google","cpc","Paid Search","paid",.85,.025,.065,.025,.075,4500,14000,110),
("CMP002","Google Search - Generic","google","cpc","Paid Search","paid",1.35,.012,.040,.012,.045,7000,20000,160),
("CMP003","Facebook Prospecting","facebook","paid_social","Paid Social","paid",.75,.008,.030,.008,.035,8000,24000,95),
("CMP004","Instagram Retargeting","instagram","paid_social","Paid Social","paid",.65,.012,.045,.015,.060,3000,11000,65),
("CMP005","YouTube Awareness","youtube","paid_video","Paid Video","paid",.30,.003,.018,.002,.018,12000,35000,75),
("CMP006","Email Newsletter","email","email","Email","owned",.12,.025,.090,.020,.085,2500,9000,18),
("CMP007","Display Retargeting","google","display","Display","paid",.48,.002,.014,.004,.025,10000,32000,55),
("CMP008","Affiliate Referral","affiliate","referral","Affiliate","partner",.55,.004,.022,.010,.050,3500,13000,45),
]
rows = []
for c in campaigns:
    cid,name,source,medium,channel,ctype,cpc,tl,th,vl,vh,il,ih,budget = c
    for day in dates:
        weekend = .88 if day.weekday() >= 5 else 1.0
        impressions = int(rng.integers(il, ih+1) * weekend)
        clicks = min(impressions, int(round(impressions * rng.uniform(tl, th))))
        spend = round(clicks * cpc * rng.uniform(.75, 1.25), 2)
        if ctype in ("owned", "partner"):
            spend = round(max(spend, rng.uniform(budget*.55, budget*1.35)), 2)
        conversions = int(rng.binomial(clicks, rng.uniform(vl, vh)))
        rows.append({
            "campaign_id":cid, "campaign_name":name, "campaign_date":day.strftime("%Y-%m-%d"),
            "source":source, "medium":medium, "channel":channel, "campaign_type":ctype,
            "impressions":impressions, "clicks":clicks, "simulated_conversions":conversions,
            "ad_spend":spend, "currency":"USD", "data_origin":"synthetic"
        })
result = pd.DataFrame(rows)
assert len(result) == 8 * 92
assert not result[["campaign_id","campaign_date"]].duplicated().any()
assert (result.impressions >= result.clicks).all()
assert (result.clicks >= result.simulated_conversions).all()
assert (result.ad_spend >= 0).all()
result.to_csv(RAW / "synthetic_advertising_spend.csv", index=False)
print(f"Generated {len(result):,} daily campaign records.")
print(f"Campaigns: {result.campaign_id.nunique()}")
print(f"Dates: {result.campaign_date.min()} to {result.campaign_date.max()}")
print(f"Total synthetic spend: ${result.ad_spend.sum():,.2f}")
