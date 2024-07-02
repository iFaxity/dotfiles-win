# Init Starship Prompt
$env:STARSHIP_CONFIG = "$HOME\.config\custom.toml"
$env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

function Invoke-Starship-TransientFunction {
  &starship module character
}

Invoke-Expression (&starship init powershell)
Enable-TransientPrompt

# Configure komorebi and whkd
$env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
$env:WHKD_CONFIG_HOME = "$HOME\.config"

# Add modules
Import-Module "PSReadLine"
Import-Module "Terminal-Icons"

# Init Zoxide
Invoke-Expression (& {
  $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
  (zoxide init --hook $hook powershell | Out-String)
})

# Init FNM
fnm env --use-on-cd | Out-String | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Import aliases
. "$PSScriptRoot/aliases.ps1"
