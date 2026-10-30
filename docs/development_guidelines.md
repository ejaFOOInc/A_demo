# Team development guidelines

- One model per file; use snake_case and prefixes stg_, hub_, link_, sat_, bv_.
- Never hardcode credentials. Use environment variables and a local profile.
- Reference upstream dbt models with `ref()` and external relations with `source()`.
- Keep source preparation in staging, historized integration in Raw Vault, and derived business rules in Business Vault.
- Every model must have a description and critical-key tests.
- Every PR should pass `dbt parse`, `dbt build` in an isolated schema, and code review.
- Changes to key hashing conventions require a migration plan.

## Developer progression
Junior: seeds, sources, staging models, YAML descriptions and not-null tests.
Medior: hubs/links/satellites, incremental models, reconciliation and singular tests.
Senior: cross-source business keys, historization and late-arrival rules, CI architecture, performance and code review.
Tech lead: platform guardrails, deployment strategy, mentoring and operational accountability.
