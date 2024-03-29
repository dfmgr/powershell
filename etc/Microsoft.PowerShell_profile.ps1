#!/usr/bin/env pwsh
Clear-Host

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import modules
oh-my-posh --init --shell pwsh --config ~/.config/powershell/theme.json | Invoke-Expression
oh-my-posh completion powershell | Out-String | Invoke-Expression
Import-Module posh-git
Import-Module posh-sshell
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$env:POSH_GIT_ENABLED = $true
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set dracula theme
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Cyan
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Autocomplete
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# posh-git settings
$GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Dracula Git Status Configuration
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function exit { exit }
function q    { exit }
function q!   { exit }
function c    { Clear-Host }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ls
function ls { /usr/bin/ls -h --color=auto $args }
function la { /usr/bin/ls -hA --color=auto $args }
function ll { /usr/bin/ls -hl --color=auto $args }
function dir { /usr/bin/ls -hD --color=auto $args }
function lla { /usr/bin/ls -hlA --color=auto $args }
function l. { /usr/bin/ls -hA $args | /usr/bin/grep -E --color=auto '^\.*'  }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Useful shortcuts for traversing directories
function  cd..  {  Set-Location ..\ }
function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }
function  ../    {  Set-Location ..\ }
function  ...   {  Set-Location ..\..\ }
function  ....  {  Set-Location ..\..\..\ }
function  ..... {  Set-Location ..\..\..\..\ }
function __cmd_exists { /usr/local/bin/cmd_exists --silent $args }

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start editor
function editor      { myeditor $args }

# Make it easy to edit this profile once it's installed
function Edit-Profile
{
    if ($host.Name -match "ise")
    {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    }
    else
    {
        editor $profile.CurrentUserAllHosts
    }
}

Function Test-CommandExists
{
  Param ($command)
  $oldPreference = $ErrorActionPreference
  $ErrorActionPreference = 'SilentlyContinue'
  try {if(Get-Command $command){RETURN $true}}
  Catch {Write-Host "$command does not exist"; RETURN $false}
  Finally {$ErrorActionPreference=$oldPreference}
} 

if (Test-CommandExists myeditor) {
        $EDITOR='myeditor'
} elseif (Test-CommandExists vim) {
    $EDITOR='vim'
} elseif (Test-CommandExists pvim) {
    $EDITOR='pvim'
} elseif (Test-CommandExists pvim) {
    $EDITOR='pvim'
} elseif (Test-CommandExists vi) {
    $EDITOR='vi'
} elseif (Test-CommandExists code) {
    $EDITOR='code'
} elseif (Test-CommandExists notepad) {
    #fallback to notepad since it exists on every windows machine
    $EDITOR='notepad'
}

function g { Set-Location $HOME\Projecys\github }
function gcom
{
	git add .
	git commit -m "$args"
}
function lazyg
{
	git add .
	git commit -m "$args"
	git push
}
Function Get-PubIP {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function reload-profile {
        & $profile
}
function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
        if ( $dir ) {
                Get-ChildItem $dir | select-string $regex
                return
        }
        $input | select-string $regex
}
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}
function df {
        get-volume
}
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
        Get-Process $name
}

"You are now entering PowerShell : " + $env:USER
