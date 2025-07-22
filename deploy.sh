#!/bin/bash

# This script now gets the APP_ID from the name of the directory it is in.
# For example, if this script is in /root/page-works/1000034059,
# the APP_ID will be 1000034059.

SOURCE_DIR="dist"
DEST_OWNER="nginx"
DEST_GROUP="nginx"

echo "--> Determining APP_ID from parent directory name..."

# Get the absolute path of the directory where the script is located
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
# The APP_ID is the last component of the directory path
APP_ID=$(basename "$SCRIPT_DIR")

if [[ -z "$APP_ID" ]]; then
  echo "Error: Could not determine the APP_ID from the directory name."
  exit 1
fi

echo "--> Successfully determined APP_ID as '$APP_ID'"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: Source directory '$SOURCE_DIR' not found."
  exit 1
fi

if ! id -u "$DEST_OWNER" >/dev/null 2>&1; then
    echo "Error: User '$DEST_OWNER' does not exist on this system."
    exit 1
fi

DEST_DIR="/app-pages/$APP_ID"

echo "Deploying app '$APP_ID' to '$DEST_DIR'..."

echo "--> Removing old directory: $DEST_DIR"
rm -rf "$DEST_DIR"
echo "--> Creating new directory: $DEST_DIR"
mkdir -p "$DEST_DIR"

echo "--> Copying new files..."
cp -a "$SOURCE_DIR/." "$DEST_DIR/"

echo "--> Setting ownership for '$DEST_OWNER:$DEST_GROUP' on $DEST_DIR"
chown -R "$DEST_OWNER:$DEST_GROUP" "$DEST_DIR"

echo "✅ Deployment complete for app '$APP_ID'. Files are owned by '$DEST_OWNER'."
