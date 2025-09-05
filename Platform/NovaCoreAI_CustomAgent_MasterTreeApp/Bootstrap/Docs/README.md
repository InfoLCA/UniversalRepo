# MasterTree Docs

Purpose: document the **recovery app** that rebuilds `NovaCore.AI.CustomAgent` deterministically.

## What this app does
- Builds a snapshot (ZIP) and a SHA-256 manifest from the live source.
- Restores the snapshot to a chosen target under the workspace mount.
- Verifies integrity against the manifest (sample or full).

## Guardrails
- No writes outside `/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp` (build) and the chosen restore target.
- Excludes machine artifacts by default: `.DS_Store`, `_CodeSignature`, `.venv/bin/python*`.

## Related
- `../Configs/restore.conf` — single source of truth for paths/flags.
- `../Scripts/*` — orchestrate build → restore → verify.
- `../Tests/test_mastertree_bootstrap.sh` — smoke test.

## Signing & Notarization
See [SIGNING_NOTARIZATION.md](./SIGNING_NOTARIZATION.md) for Developer ID signing, notarization, and stapling steps.

## Notarization Status
See [NOTARIZATION_STATUS.md](./NOTARIZATION_STATUS.md) for RequestUUID, results, and stapling validation.

## Final Release
See [FINAL_RELEASE_CHECKLIST.md](./FINAL_RELEASE_CHECKLIST.md) for RC→Final steps.
