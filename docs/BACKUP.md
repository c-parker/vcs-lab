# Backup and Recovery Policy

## Backup Strategy (3 layers)
| Layer | Method | Frequency | Retention |
|---|---|---|---|
| 1. Remote | GitHub (every push) | Continuous | Permanent |
| 2. Automated | GitHub Actions `Repository Backup` workflow (git bundle artifact) | Weekly, Sundays 06:00 UTC + on demand | 30 days |
| 3. Local | `scripts/backup.sh` (timestamped git bundle in ~/git-backups) | Weekly + before major merges | 10 most recent |

Every backup is verified with `git bundle verify` immediately after it is created.

## Recovery Procedure
1. `git clone <backup-file>.bundle vcs-lab`
2. `cd vcs-lab`
3. `git remote set-url origin https://github.com/c-parker/vcs-lab.git`
4. `git fetch` and `git status` (confirm up to date with origin/main)
5. `git fsck --full` (confirm no errors)
6. `npm install` (rebuild node_modules)
7. `cp .env.example .env` and restore secrets from the password manager
8. `npm start` (confirm the app runs)

## Backup and Restore Test Log
| Date | Backup type | Verified? | Restore tested? | Restore time | Result |
|---|---|---|---|---|---|
| 11/19/2026 | GitHub Actions bundle (repo-backup-1) | Yes | Yes | < 1 sec | 56/56 objects, full history restored, fsck clean |
| 11/19/2026 | Local bundle (vcs-lab_2026-11-19_1700) | Yes | Yes | 0.21 sec | 56/56 objects, full history restored, fsck clean |
| 11/19/2026 | Full disaster simulation (local bundle) | Yes | Yes | 0.23 sec clone + 4 sec npm install (under 1 min total) | Repo, GitHub remote, dependencies, and app fully recovered |

## Testing Schedule
- Restore tests are performed **monthly** and after any change to the backup process.
- Each test is recorded in the log above.
- A test passes only if: full history is present, `git fsck` reports no errors, and the app starts.

## Lessons Learned (11/19/2026 test)
- The first attempt to move the original folder failed with `Permission denied` because the folder was open in another program. Close editors and File Explorer before recovery.
- Restored repositories point `origin` at the bundle file; the remote must be reset to GitHub (step 3).

## Not Included in Backups (by design)
- `node_modules/`: rebuilt with `npm install` from `package-lock.json`
- `.env`: secrets are never stored in Git; restore from the password manager