# Ionic Appflow setup

This repository uses XcodeGen instead of committing an `.xcodeproj`.

Appflow configuration:

- `appflow.config.json` sets `iosPath` to the repo root and defines a `before_build` hook.
- `scripts/appflow_before_build.sh` installs XcodeGen and generates `TaskiAI.xcodeproj` before Appflow steps run.

No changes to GitHub Actions are required.
