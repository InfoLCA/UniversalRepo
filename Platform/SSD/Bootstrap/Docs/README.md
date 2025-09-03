# Docs  
This folder stores specifications, design notes, and user-facing documentation for the SSD bootstrap.

## 🔬 NovaCore SSD Bootstrap — Self-Test Procedure

Before applying the bootstrap to a real SSD volume, run the self-test.  
This validates the script logic in a temporary workspace without touching system files.

### Run the Test
```bash
/Volumes/Workspace/UniversalRepo/Platform/SSD/Bootstrap/Tests/test_ssd_bootstrap.sh

Expected Output

[ok] bootstrap smoke test passed

What It Does
	•	Creates a throwaway directory under /tmp/test_ssd_XXXX
	•	Runs ssd_bootstrap.sh --target in DRY_RUN mode
	•	Verifies expected markers (Bootstrap completed)
	•	Cleans up automatically

Safety
	•	✅ Non-destructive (uses /tmp)
	•	✅ Requires no sudo
	•	✅ Ensures bootstrap logic is intact before production use

