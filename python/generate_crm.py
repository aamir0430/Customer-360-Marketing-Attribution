from pathlib import Path
import pandas as pd
import numpy as np
from faker import Faker

SEED = 42
N_CUSTOMERS = 5000
N_MAPPED = 3500
N_PURCHASING_MAPPED = 2500
ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
USERS_FILE = RAW / "01_export_ga4_users_results.csv"

# Put your downloaded BigQuery GA4 users export in data/raw using the filename above.
users = pd.read_csv(USERS_FILE, dtype={"user_pseudo_id": "string"}, low_memory=False)

required = {"user_pseudo_id", "first_seen_date", "purchase_events"}
missing = required - set(users.columns)
if missing:
    raise ValueError(f"GA4 users export is missing columns: {sorted(missing)}")
if users["user_pseudo_id"].isna().any() or users["user_pseudo_id"].duplicated().any():
    raise ValueError("GA4 user_pseudo_id must be non-null and unique.")

purchasers = users[pd.to_numeric(users["purchase_events"], errors="coerce").fillna(0) > 0]
nonpurchasers = users[pd.to_numeric(users["purchase_events"], errors="coerce").fillna(0) == 0]
n_nonpurchasing = N_MAPPED - N_PURCHASING_MAPPED
if len(purchasers) < N_PURCHASING_MAPPED or len(nonpurchasers) < n_nonpurchasing:
    raise ValueError("Not enough purchaser/non-purchaser GA4 users for configured sample.")

rng = np.random.default_rng(SEED)
Faker.seed(SEED)
fake = Faker()

sample = pd.concat([
    purchasers.sample(n=N_PURCHASING_MAPPED, random_state=SEED),
    nonpurchasers.sample(n=n_nonpurchasing, random_state=SEED)
], ignore_index=True).sample(frac=1, random_state=SEED).reset_index(drop=True)

crm, mapping = [], []
for i in range(N_CUSTOMERS):
    cid, sid = f"CUST{i+1:06d}", f"SYNUSER{i+1:06d}"
    if i < N_MAPPED:
        row = sample.iloc[i]
        first_seen = pd.to_datetime(row["first_seen_date"])
        start = max(pd.Timestamp("2019-11-01"), first_seen - pd.Timedelta(days=365))
        reg_date = fake.date_between_dates(date_start=start.date(), date_end=first_seen.date())
        mapping.append({
            "user_pseudo_id": str(row["user_pseudo_id"]),
            "synthetic_user_id": sid,
            "customer_id": cid,
            "match_method": "synthetic_seeded_mapping",
            "mapping_is_synthetic": True,
            "ga4_purchase_events_at_export": int(row["purchase_events"]),
            "ga4_first_seen_date": str(row["first_seen_date"])
        })
    else:
        reg_date = fake.date_between_dates(
            date_start=pd.Timestamp("2020-01-01").date(),
            date_end=pd.Timestamp("2021-01-31").date()
        )
    crm.append({
        "customer_id": cid,
        "synthetic_user_id": sid,
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "email": f"{cid.lower()}@example.test",
        "gender": rng.choice(["Female", "Male", "Other"], p=[0.48, 0.48, 0.04]),
        "city": fake.city(),
        "country": fake.country(),
        "registration_date": reg_date.isoformat(),
        "customer_status": rng.choice(["Active", "Inactive"], p=[0.82, 0.18]),
        "loyalty_tier": rng.choice(
            ["Bronze", "Silver", "Gold", "Platinum"],
            p=[0.45, 0.30, 0.18, 0.07]
        ),
        "data_origin": "synthetic"
    })

RAW.mkdir(parents=True, exist_ok=True)
pd.DataFrame(crm).to_csv(RAW / "synthetic_crm_customers.csv", index=False)
pd.DataFrame(mapping).to_csv(RAW / "identity_mapping.csv", index=False)
print(f"Created {N_CUSTOMERS:,} CRM customers and {len(mapping):,} synthetic identity mappings.")
