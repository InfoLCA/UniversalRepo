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

