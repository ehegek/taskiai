#!/usr/bin/env bash
set -euo pipefail

# Appflow runs from the repo root. Ensure XcodeGen is installed and generate the project.
if ! command -v xcodegen >/dev/null 2>&1; then
  echo "Installing XcodeGen..."
  brew update
  brew install xcodegen || brew install xcodegen@2
fi

# Generate Xcode project from Project.yml at repo root
rm -rf TaskiAI.xcodeproj
xcodegen generate --spec Project.yml --project-root .

# Print confirmation
ls -la TaskiAI.xcodeproj || { echo "Xcode project not generated"; exit 1; }
