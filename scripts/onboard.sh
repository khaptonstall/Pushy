#!/bin/bash

# Verify the script has been executed.
echo "Running onboarding script..."

# 1 - Install and Verify Build Tools

# Ensure that homebrew is installed.
command -v brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed."; exit 1; }

# Ensure that homebrew is installed or install it.
if ! [ -x "$(command -v brew)" ]; then
  echo 'Installing homebrew...'
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# Ensure that mint is installed or install it.
command -v mint >/dev/null 2>&1 || { echo >&2 "Mint is not installed."; exit 1; }
if ! [ -x "$(command -v mint)" ]; then
  echo 'Installing mint...'
  brew install mint
fi

# 2 - Install Git Hooks

# If there are any scripts in the scripts/git-hooks folder,
# copy them into the .git/hooks folder which is not source controlled.
# This will replace any existing files.
cp -R -a scripts/git-hooks/. .git/hooks

# Verify the script has completed.
echo "Onboarding complete."
