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

# Set Android SDK directory in local.properties
SDK_DIR="$HOME/Android/Sdk"
LOCAL_PROPERTIES="local.properties"

# Create or update local.properties with SDK path
if [[ -f "$LOCAL_PROPERTIES" ]]; then
    # Update existing file
    if grep -q "sdk.dir=" "$LOCAL_PROPERTIES"; then
        sed -i.bak "s|sdk.dir=.*|sdk.dir=$SDK_DIR|" "$LOCAL_PROPERTIES" && rm -f "$LOCAL_PROPERTIES.bak"
        echo "✓ Updated existing sdk.dir in $LOCAL_PROPERTIES"
    else
        echo "sdk.dir=$SDK_DIR" >> "$LOCAL_PROPERTIES"
        echo "✓ Added sdk.dir to existing $LOCAL_PROPERTIES"
    fi
else
    # Create new file
    echo "sdk.dir=$SDK_DIR" > "$LOCAL_PROPERTIES"
    echo "✓ Created $LOCAL_PROPERTIES with sdk.dir"
fi

# Verify SDK directory exists
if [[ ! -d "$SDK_DIR" ]]; then
    echo "⚠️  Warning: Android SDK directory not found at $SDK_DIR" >&2
    echo "   You may need to install the Android SDK or update the path"
fi

# Execute build and installation commands
do_cmd ./gradlew assembleDebug
do_cmd "$HOME/.bin/tools/install_and_run_apk.sh" "termux-app" "debug"

echo "🎉 All tasks completed successfully!"
