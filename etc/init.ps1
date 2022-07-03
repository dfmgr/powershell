#!pwsh
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
Install-Module -Name PowerShellGet -AllowPrerelease -Force
Install-Module -Name PackageManagement -Force
oh-my-posh init pwsh --config ~/.config/powershell/theme.json | Invoke-Expression
Install-Module -Name posh-git -Force
Install-Module -Name posh-sshell -Force
Install-Module -Name Posh-ACME -Force
Install-Module -Name posh-alias -Force
Install-Module -Name PoshNotify -Force
Install-Module -Name PoshHosts -Force
