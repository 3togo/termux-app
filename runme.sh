#!/bin/bash

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

do_cmd() {
    echo "➡️ Executing: $*"
    # Execute command and capture exit code
    if "$@"; then
        echo "✅ Command succeeded: $*"
    else
        local err=$?
        echo "❌ Command failed with exit code $err: $*" >&2
        exit "$err"
    fi
}

# Set JAVA_HOME
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

# Verify JAVA_HOME exists
if [[ ! -d "$JAVA_HOME" ]]; then
    echo "❌ Error: JAVA_HOME not found at $JAVA_HOME" >&2
    exit 1
fi

echo "✓ Using JAVA_HOME: $JAVA_HOME"

# Execute build and installation commands
do_cmd ./gradlew assembleDebug
do_cmd "$HOME/.bin/tools/install_and_run_apk.sh" "termux-app" "debug"

echo "🎉 All tasks completed successfully!"
