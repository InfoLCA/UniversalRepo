# Signing & Notarization — NovaCore MasterTree Bootstrap v1.0.0

## Prereqs (once)
- Apple Developer account
- Install cert to keychain: **Developer ID Application: Your Name (TEAMID)**
- Xcode CLT: `xcode-select --install`
- Login for notarytool: `xcrun notarytool store-credentials novacore-profile --apple-id "YOU@EMAIL" --team-id TEAMID --password APP_SPECIFIC_PW`

## 1) Codesign (real cert)
```bash
codesign --deep --force --options runtime --timestamp   --sign "Developer ID Application: Your Name (TEAMID)"   "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"
codesign --verify --strict --verbose=2 "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"
```

## 2) Zip for notarization (correct tool/flags)
Use `ditto` (not `zip`) and keep parent:
```bash
/usr/bin/ditto -c -k --keepParent "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app" "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore_MasterTree_Bootstrap_v1.0.0.app.zip"
```

## 3) Notarize and wait
```bash
xcrun notarytool submit "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore_MasterTree_Bootstrap_v1.0.0.app.zip" --keychain-profile "novacore-profile" --wait
```

## 4) Staple the ticket
```bash
xcrun stapler staple "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"
spctl --assess --type execute --verbose "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"
```

## 5) Release checklist (final)
- Rebuild deterministic ZIPs if needed (no content changes expected from stapling).
- Update release notes to mark **signed + notarized**.
- Optionally create DMG/PKG; staple those as well.

## Troubleshooting
- `codesign --verify --verbose=4 "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"` to inspect signature.
- Gatekeeper quarantine: `xattr -lr "/Volumes/workspace/UniversalRepo/Platform/NovaCoreAI_CustomAgent_MasterTreeApp/Bootstrap/Apps/NovaCore MasterTree Bootstrap.app"` (should be clean after notarization).
- If team/cert mismatch: re-run codesign with exact certificate CN shown by:
  `security find-identity -v -p codesigning`.

