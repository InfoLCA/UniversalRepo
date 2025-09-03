-- NovaCore SSD Bootstrap (AppleScript wrapper)
set scriptPath to "/Volumes/Workspace/UniversalRepo/Platform/SSD/Bootstrap/Scripts/ssd_bootstrap.sh"

-- Ask user to pick the SSD root (e.g., /Volumes/YourSSD)
set targetFolder to choose folder with prompt "Select the SSD root (e.g., /Volumes/YourSSD):"
set targetPath to POSIX path of targetFolder

try
  -- Run the bootstrap with admin privileges
  do shell script "/bin/bash -c " & quoted form of (scriptPath & " --target " & quoted form of targetPath & " --no-dry-run") with administrator privileges
  display dialog "NovaCore SSD Bootstrap completed successfully." buttons {"OK"} default button 1 with icon note
on error errMsg number errNum
  display dialog "Bootstrap failed (" & errNum & "): " & errMsg buttons {"OK"} default button 1 with icon stop
end try
