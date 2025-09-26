# Docker Sandbox App — Architecture Overview

## Purpose
The Docker Sandbox App provides an isolated, enterprise-grade execution environment for AI agents and workflows.  
It ensures original files remain protected while enabling experimentation, development, and controlled deployment.

---

## System Components
- **Phases (0–12)**: Encapsulated scripts that enforce sandbox lifecycle (bootstrap → intervention).  
- **Configs/**: Central configuration (YAML, JSON) defining mounts, limits, and policies.  
- **src/**: Monitoring agents, validators, and supporting logic.  
- **observability/**: Logs, metrics, and reports for runtime introspection.  
- **.state/**: Immutable state progression markers with SHA-256 locks.  
- **Capsules/**: Year/Month/Day outputs capturing artifacts, reports, and evidence.

---

## Trust Boundaries
- **Host System (macOS, SSD volumes)**: Protected, read-only.  
- **Docker Container (sandbox)**: Writable working set, enforced limits.  
- **Network**: Restricted by Phase 2 network controls (allowlist, denylist).  
- **Approval Workflow**: Gated at Phase 9+ for cost, API, and decision approvals.

---

## Data Flows
1. **Originals → Read-Only Mounts**  
   Host files mounted into container with `:ro` flags.  

2. **Working Set → Writable Layer**  
   Container workspace where AI operates, subject to monitoring & rollback.  

3. **Telemetry → Observability/**  
   Logs, metrics, breaker states, and digests stored immutably.  

4. **Capsules → Evidence Store**  
   Daily artifacts archived with SHA-256 and Git tags for reproducibility.  

---

## Guardrails
- **File-system immutability** via read-only mounts.  
- **Step-gates** ensure no phase advancement without passing regression tests.  
- **Circuit breakers** trigger when CPU/MEM/API thresholds exceed safe bounds.  
- **Rollback recovery** ensures snapshots can restore a known-good state.  

---

## Step Gate Integration
Every phase invokes `step_gate.sh` to validate:
- Previous tests passed.  
- State file updated with SHA-256 lock.  
- Telemetry entry emitted.  

---

## Glossary
- **Working Set**: Editable copy inside container.  
- **Originals**: Read-only protected data on SSD.  
- **Step Gate**: Script that blocks advancement unless regression passes.  
- **Capsule**: Immutable evidence artifact (JSON, MD, YAML).  
