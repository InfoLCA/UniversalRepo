# Final Release Checklist — NovaCore MasterTree Bootstrap v1.0.0

## Preconditions
- Developer ID Application cert installed in login keychain.
- `security find-identity -v -p codesigning` shows your cert (TEAMID noted).
- Notary profile stored: `xcrun notarytool store-credentials novacore-profile ...`

## Steps (RC → Final)
1) **Codesign** (real cert)  
   `codesign --deep --force --options runtime --timestamp --sign "Developer ID Application: Your Name (TEAMID)" "<APP_PATH>"`
2) **Zip for notarization** (use ditto, keep parent)  
   `/usr/bin/ditto -c -k --keepParent "<APP_PATH>" "<APP_ZIP>"`
3) **Notarize & wait**  
   `xcrun notarytool submit "<APP_ZIP>" --keychain-profile novacore-profile --wait`
4) **Staple & validate**  
   `xcrun stapler staple "<APP_PATH>" && spctl --assess --type execute --verbose "<APP_PATH>"`
5) **Tag final**  
   `git tag -a mastertree-bootstrap-v1.0.0 -m "Final signed+notarized" && git push origin mastertree-bootstrap-v1.0.0`
6) **GitHub Release (final)**  
   - Edit RC notes → mark signed/notarized.  
   - Upload notarized **.app** (or DMG/PKG).  
   - Keep existing snapshot ZIP + manifest + CHECKSUMS.
7) **Docs & status**  
   - Update `NOTARIZATION_STATUS.md` with RequestUUID / Accepted result.  
   - Add any post-flight notes to `CLOSURE.md`.

## Post-release (optional)
- Publish SBOM/provenance (Sigstore/GitHub Attestations).
- CI job to reproduce deterministic snapshot and compare hashes.

