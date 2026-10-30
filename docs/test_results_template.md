# Test execution report (fill after running)

| Batch | Models PASS | Tests PASS | Tests FAIL | Notes |
|---|---:|---:|---:|---|
| 1 | | | | Initial load |
| 2 | | | | Customer and policy changes |
| 3 | | | | New customer and policy |
| 4 | | | | Late-arriving customer event |

Capture counts from Snowflake and retain `evidence/batch_*.log`. Do not claim unexecuted tests passed.

Suggested intentional failure: insert a NULL customer ID in the seed, rerun `dbt seed` and `dbt test --select source:raw`, capture failure, restore original seed, rerun and document resolution.
