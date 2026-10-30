# Architecture and design decisions

RAW (dbt seeds) -> STAGING (views) -> RAW_VAULT (incremental tables) -> BUSINESS_VAULT (current-state view).

## Business keys and grain
- HUB_CUSTOMER: CUSTOMER_ID; HUB_POLICY: POLICY_ID. Assumes globally unique identifiers; production multi-tenant systems may need a BKCC.
- LINK_CUSTOMER_POLICY: one row per (CUSTOMER_ID, POLICY_ID).
- SAT_CUSTOMER: descriptive changes per customer observed load event.
- SAT_POLICY: descriptive changes per policy observed load event.

## Hashes
SHA2-256 over uppercase/trimmed string values, null/empty -> ^^, components separated by ||. Production systems should implement typed canonicalization, escaping, and collision handling policy.

## Temporal semantics
`load_datetime` represents ingestion time supplied by the sample source; `effective_at` is the business effective timestamp. The Raw Vault orders versions by load_datetime, not by effective_at. The batch 4 customer event is late arriving and demonstrates this distinction. Business-effective reconstruction requires separate Business Vault logic and clear conflict rules.

## Simplifications and limitations
- The source sample is cumulative and tiny; incremental satellites scan all staged source rows and MERGE on deterministic event IDs. A large production solution should use bounded CDC/watermarks, persistent audit checkpoints, and robust replay semantics.
- Satellite changes are compared in load-time order; same-timestamp conflicting events require source sequence or tie-breaking policy.
- Hub/link merge may update existing metadata if rerun with changed source history; production Raw Vault should use insert-only or a merge policy that never updates historical metadata.
- No hard-delete handling, multi-active satellites, effectivity satellite, or cross-system identity resolution.
- For simplicity, role defaults to ACCOUNTADMIN in example profile; use least privilege in production.
