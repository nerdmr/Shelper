#!/bin/bash

# Installation script for shelper.sh without requiring sudo

# Define the target directory
TARGET_DIR="$HOME/.local/bin"
CONFIG_FILE="$HOME/.shelper_config"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Determine the directory of the install.sh script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Prompt for the API key
read -p "Enter your API key: " API_KEY

# Store the API key in a configuration file
echo "API_KEY=$API_KEY" > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# Create a symlink to the script in the target directory
echo "Creating a symlink to shelper.sh in $TARGET_DIR..."
ln -sf "$SCRIPT_DIR/bin/shelper.sh" "$TARGET_DIR/shelper"

# Uncomment the following lines to copy the script instead of creating a symlink
# echo "Copying shelper.sh to $TARGET_DIR..."
# cp "$SCRIPT_DIR/bin/shelper.sh" "$TARGET_DIR/shelper"

# Make the script executable
chmod +x "$TARGET_DIR/shelper"

# Add the target directory to the user's PATH if it's not already there
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo "Adding $TARGET_DIR to your PATH..."
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.bashrc"
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.zshrc"
    echo "Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to update your PATH."
fi

echo "Installation complete. You can now run 'shelper' from any terminal."
echo "Your API key has been stored in $CONFIG_FILE."
