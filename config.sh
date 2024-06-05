#!/bin/bash

# Configuration script for shelper.sh

# Define the configuration file
CONFIG_FILE="$HOME/.shelper_config"

# Prompt for the new API key
read -p "Enter your new API key: " NEW_API_KEY

# Update the configuration file
echo "Updating configuration file $CONFIG_FILE..."
echo "API_KEY=$NEW_API_KEY" > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

echo "Configuration update complete. Your new API key has been saved."
