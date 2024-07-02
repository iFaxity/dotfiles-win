$ErrorActionPreference = 'Stop'

# Define constants
$BACKUP_DIR = "$HOME\.dotfiles-backup"

function dotfiles() {
  git --git-dir "$HOME\.dotfiles" --work-tree "$HOME" $args
}

# Clone the dotfiles repo
git clone --bare git@github.com:iFaxity/dotfiles-win.git "$HOME\.dotfiles"

# Create backup dir of existing config
New-Item -ItemType Directory -Force $BACKUP_DIR

# Try checkout config (suppress output)
try {
  dotfiles checkout | Out-Null
} catch {
  #  Backing up pre-existing dot files.
  Write-Host "Backing up pre-existing dot files."

  # Get list of files to backup
  $files = dotfiles checkout 2>&1 | Select-String -Pattern '\s+\.' | ForEach-Object {
    $_.Matches[0].Groups[1].Value
  }

  # Move files into its respective directory
  foreach ($file in $files) {
    $path = (Get-Path -Path "$HOME/$file" -Relative).ToString()
    $parent_dir = (Split-Path -Path "$BACKUP_DIR/$path" -Parent)

    # Create parent dir for file
    New-Item -ItemType Directory -Force $parent_dir

    # Move file to backup dir path
    Move-Item -Path "$HOME/$file" -Destination "$BACKUP_DIR/$path"
  }

  # Try checkout again
  dotfiles checkout
}

if ($lastExitCode -eq 0) {
  Write-Host "Checked out config."

  # Set git config for repo
  dotfiles config status.showUntrackedFiles no
} else {
  Write-Host "Failed to check out config!"
}
