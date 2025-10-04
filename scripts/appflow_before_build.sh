#!/usr/bin/env bash
set -euo pipefail

echo "[Appflow] Pre-build: ensure XcodeGen and generate Xcode project"

# Ensure PATH includes common Homebrew location on Apple Silicon CI
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Install XcodeGen if needed
if ! command -v xcodegen >/dev/null 2>&1; then
  echo "[Appflow] Installing XcodeGen via Homebrew..."
  if command -v brew >/dev/null 2>&1; then
    brew update || true
    brew install xcodegen || brew install xcodegen@2 || true
  fi
fi

# Fallback: install XcodeGen using Mint if Homebrew is unavailable
if ! command -v xcodegen >/dev/null 2>&1; then
  echo "[Appflow] Installing XcodeGen via Mint (fallback)..."
  if ! command -v mint >/dev/null 2>&1; then
    brew install mint || true
  fi
  mint install yonaskolb/XcodeGen || true
  if [ -x "$HOME/.mint/bin/xcodegen" ]; then
    export PATH="$HOME/.mint/bin:$PATH"
  fi
fi

# Final check
command -v xcodegen >/dev/null 2>&1 || { echo "[Appflow] XcodeGen not available"; exit 1; }

# Generate Xcode project from Project.yml at repo root
rm -rf TaskiAI.xcodeproj
xcodegen generate --spec Project.yml --project-root .

# Print confirmation
ls -la TaskiAI.xcodeproj || { echo "[Appflow] Xcode project not generated"; exit 1; }
