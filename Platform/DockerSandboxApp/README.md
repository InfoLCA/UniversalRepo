# DockerSandboxApp — Enterprise Sandbox & Guardrails

## Purpose
A controlled Docker-based workspace that lets AI/agents operate **safely** on a mounted working copy while your **original data stays read-only and immutable**. Adds approvals, validation, cost/rate limits, and auditable rollback.

## Objectives
- File safety: read-only mounts for originals, writeable working copy.
- Network safety: default-deny; least-privilege egress with allowlists.
- Decision safety: approval workflow + validation gate(s).
- Cost safety: API budgets, rate limits, and circuit breakers.
- Observability: structured logs, metrics, and daily digests.
- Recovery: snapshots, rollbacks, and sealed checkpoints.

## Repository Layout
Platform/DockerSandboxApp/
├─ phases/                  # Phase scripts (0–12)
├─ configs/                 # Docker, policies, budgets, allowlists
├─ rules/                   # Sandbox rules + locks
├─ src/monitor/             # telemetry, digests, janitor
├─ src/validators/          # preflight & policy validators
├─ observability/
│  ├─ logs/                 # jsonl logs
│  ├─ metrics/              # prometheus-friendly metrics
│  └─ reports/              # markdown reports/digests
├─ docs/                    # architecture & ops docs
└─ .state/                  # progress & immutability seals
## Phases (0–12) — High Level
- **P0 Bootstrap**: init repo, docs, locks, progress seal.
- **P1 Env Setup**: Dockerfile, compose, non-root user, resource caps.
- **P2 Network Controls**: default-deny, allowlists, DNS pinning, egress tokens.
- **P3 FS Protection**: read-only originals, copy-on-write working set, checksums.
- **P4 Monitoring**: telemetry, resource guardrails, circuit-breaker signals.
- **P5 Logging**: jsonl action logs, redactors, rotation & retention.
- **P6 Policy Engine**: rule sets (permit, one-command, enterprise-only phrasing, global scope).
- **P7 Compliance**: SOX/GDPR checklist, data-class tags, export controls.
- **P8 Rollback/Recovery**: snapshots, atomic restore, disaster drill.
- **P9 Approval Workflows**: action classes, thresholds, human gates, escalation.
- **P10 Decision Validation**: independent validator pass/fail, converge-or-escalate.
- **P11 Cost Guardrails**: budgets, rate limits, hard stops, spend telemetry.
- **P12 Human Intervention**: pause/resume points, urgent bypass, audit reasons.

## Safety Model
1) **Technical isolation** (Docker, RO mounts, resource caps).  
2) **Decision control** (approvals, validators, human-in-the-loop).  
3) **Cost control** (budgets/rates/circuit breakers).  
4) **Auditability** (structured logs, immutable seals, tags).

## Quick Start (after phases are implemented)
- `phases/phase1_env_setup.sh` → build base image
- `phases/phase2_network_controls.sh` → set egress rules
- `phases/phase3_fs_protection.sh` → mount RO originals + RW working set
- `phases/phase4_monitoring.sh` → enable telemetry & guardrails
- … continue sequentially with step gates

## Governance
- All authored files must have a `.sha256` lock.
- Progress tracked in `.state/docker_sandbox_progress.md` with UTC timestamps.
- PR template/checklist required; tickets enforced in commit messages.

## Telemetry & Reporting
- Logs: `observability/claude-sandbox/logs/ct.jsonl`
- Metrics: `observability/metrics/*.prom`
- Daily digest + health report in `observability/reports/`

## Glossary
- **Working Set**: editable copy inside the container.
- **Originals**: read-only source data outside the container.
- **Step Gate**: script that blocks next phase unless tests pass.

