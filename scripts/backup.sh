#!/bin/bash
# Creates a timestamped, verified full backup of the repository
REPO_DIR="$HOME/vcs-lab"
BACKUP_DIR="$HOME/git-backups"
DATE=$(date +%Y-%m-%d_%H%M)

mkdir -p "$BACKUP_DIR"
cd "$REPO_DIR" || exit 1

git bundle create "$BACKUP_DIR/vcs-lab_$DATE.bundle" --all
git bundle verify "$BACKUP_DIR/vcs-lab_$DATE.bundle" && echo "Backup OK: $BACKUP_DIR/vcs-lab_$DATE.bundle"

# keep only the 10 most recent backups
ls -t "$BACKUP_DIR"/vcs-lab_*.bundle | tail -n +11 | xargs -r rm --