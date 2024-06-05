#!/bin/bash

# Uninstallation script for shelper.sh

# Define the target directory and configuration file
TARGET_DIR="$HOME/.local/bin"
SCRIPT_NAME="shelper"
CONFIG_FILE="$HOME/.shelper_config"

# Remove the symlink from the target directory
if [ -L "$TARGET_DIR/$SCRIPT_NAME" ]; then
  echo "Removing symlink $TARGET_DIR/$SCRIPT_NAME..."
  rm "$TARGET_DIR/$SCRIPT_NAME"
  echo "$SCRIPT_NAME symlink has been removed."
else
  echo "Error: $SCRIPT_NAME symlink not found in $TARGET_DIR."
fi

# Uncomment the following lines to remove the copied script instead of the symlink
# if [ -f "$TARGET_DIR/$SCRIPT_NAME" ]; then
#   echo "Removing $TARGET_DIR/$SCRIPT_NAME..."
#   rm "$TARGET_DIR/$SCRIPT_NAME"
#   echo "$SCRIPT_NAME has been removed."
# else
#   echo "Error: $SCRIPT_NAME not found in $TARGET_DIR."
# fi

# Remove the configuration file
if [ -f "$CONFIG_FILE" ]; then
  echo "Removing configuration file $CONFIG_FILE..."
  rm "$CONFIG_FILE"
  echo "Configuration file has been removed."
else
  echo "Configuration file not found."
fi

echo "Uninstallation complete."
