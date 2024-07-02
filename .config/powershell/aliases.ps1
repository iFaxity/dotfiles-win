###################
# Aliases        #
###################

# General
New-Alias -Name "whereis" -Value "where.exe"

# FNM
New-Alias -Name "nvm" -Value "fnm"

# Litium cloud CLI
New-Alias -Name 'lc' -Value 'litium-cloud'

# rm -rf
New-Alias -Name 'rimraf' -Value 'Remove-Item -Recurse -Force'

New-Alias -Name 'nano' -Value 'C:\Program Files\Git\usr\bin\nano.exe'

# dotfiles alias
function dotfiles() {
  git --git-dir "$HOME\.dotfiles" --work-tree "$HOME" $args
}

# Watch-Command function to run command until end
function Watch-Command(
  [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
  [ScriptBlock[]] $Process,
  [Parameter(Mandatory=$false)]
  [ValidateRange(1, [int]::MaxValue)]
  [int] $Interval = 10
) {
  while($true) {
    Clear-Host

    # Execute the process
    $Process.Invoke()

    Start-Sleep 10
  }
}
