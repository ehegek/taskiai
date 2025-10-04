# Ionic Appflow setup

This repository now commits the generated `.xcodeproj` so Appflow can pick it up without custom config.

Workflow:

- Run the manual workflow `Generate Xcode Project` in GitHub Actions to (re)generate and commit `TaskiAI.xcodeproj` from `Project.yml`.
- Appflow: set iOS Project Path to `.`; no hooks/config needed.

Notes:

- `scripts/appflow_before_build.sh` remains for local use but is not required by Appflow anymore.
