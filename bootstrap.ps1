# Install powershell profile
New-Item -ItemType Directory -Force -Path C:\Users\matt\Documents\WindowsPowerShell
New-Item -ItemType SymbolicLink -Path C:\Users\matt\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -Target "windows\Profile.ps1"
