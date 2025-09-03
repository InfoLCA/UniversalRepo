# UniversalRepo

Master index for platform tooling and apps.

## Structure
- **Platform/** – OS & device setup tools
  - **SSD/** – Storage bootstrap & hygiene
    - **Bootstrap/** – CLI + app launcher
      - [Docs](Platform/SSD/Bootstrap/Docs/README.md)
      - [Scripts](Platform/SSD/Bootstrap/Scripts/README.md)
      - [Configs](Platform/SSD/Bootstrap/Configs/README.md)
      - [Tests](Platform/SSD/Bootstrap/Tests/README.md)
      - [Examples](Platform/SSD/Bootstrap/Examples/README.md)
- **Agents/** *(planned)* – Standalone AI agent repos (e.g., NovaCore AI Custom Agent)
- **Docs/** *(planned)* – Architecture, governance, runbooks

## Quick Start (SSD Bootstrap)
- CLI (dry run):  
  `DRY_RUN=1 /Volumes/Workspace/UniversalRepo/Platform/SSD/Bootstrap/Scripts/ssd_bootstrap.sh --target /Volumes/Workspace`
- CLI (apply):  
  `/Volumes/Workspace/UniversalRepo/Platform/SSD/Bootstrap/Scripts/ssd_bootstrap.sh --target /Volumes/Workspace`
- macOS app launcher:  
  `open "/Volumes/Workspace/UniversalRepo/Platform/SSD/Bootstrap/Apps/NovaCore SSD Bootstrap.app"`

## Conventions
- Layered READMEs: Root → subfolder → component.
- Idempotent scripts; no destructive disk ops in v1.
- macOS system folders are archived when permissions allow.

SSD Bootstrap v1.0.0

The NovaCore SSD Bootstrap prepares any SSD volume with FAANG-style hygiene:
	•	Creates .nova/ structure (manifests, logs, keys, docs, status, archive).
	•	Adds .gitignore for macOS metadata (.DS_Store, .Spotlight-V100, etc).
	•	Archives system folders (.Spotlight-V100, .TemporaryItems) safely.
	•	Creates sentinel .NOVACORE_OK for downstream tools to verify readiness.
	•	Provides a self-test script under Tests/.
	•	Packaged as both a bash script and a double-clickable macOS app.

🔗 Release

👉 SSD Bootstrap v1.0.0

https://github.com/InfoLCA/UniversalRepo/releases/tag/ssd-bootstrap-v1.0.0

Included assets:
	•	ssd_bootstrap.sh (script, non-destructive, idempotent)
	•	NovaCore-SSD-Bootstrap.app.zip (macOS GUI wrapper for one-click setup)

🚀 Usage

Option A: Script (CLI)

# Dry-run (safe preview)
DRY_RUN=1 ./ssd_bootstrap.sh --target /Volumes/MySSD

# Real run
./ssd_bootstrap.sh --target /Volumes/MySSD

Option B: macOS App (GUI)
	1.	Download and unzip NovaCore-SSD-Bootstrap.app.zip.
	2.	Double-click NovaCore SSD Bootstrap.app.
	3.	Choose your target SSD volume when prompted.

✅ Verify

# Check nova structure
find /Volumes/MySSD/.nova -type d | wc -l

# Check sentinel
test -f /Volumes/MySSD/.NOVACORE_OK && echo OK_sentinel


## SSD Bootstrap Releases
- [v2.0.0](https://github.com/InfoLCA/UniversalRepo/releases/tag/ssd-bootstrap-v2.0.0)
- [v1.0.0](https://github.com/InfoLCA/UniversalRepo/releases/tag/ssd-bootstrap-v1.0.0)
