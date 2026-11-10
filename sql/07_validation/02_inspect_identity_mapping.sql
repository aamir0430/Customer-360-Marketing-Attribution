/*
Project: Customer 360 and Marketing Attribution
Phase: 2 - Identity Resolution
Step: 2.2 - Examine Identity Mapping

Purpose:
Inspect sample records from the identity mapping
table to understand how GA4 users are linked
to synthetic CRM customers.

Source:
customer_360_raw.identity_mapping
*/

SELECT *
FROM `customer-360-mta.customer_360_raw.identity_mapping`
LIMIT 20;