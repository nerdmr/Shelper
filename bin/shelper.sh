#!/bin/bash

# Initialize variables
MODEL="gpt-4o" # or any other model you want to use
ARG="$@"

# Load the API key from the configuration file
CONFIG_FILE="$HOME/.shelper_config"

if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Configuration file not found! Please run the install script to set up your API key."
  exit 1
fi

# Define system and user messages
SYSTEM_MESSAGE="You are a command line tool that provides commands to be pasted at a terminal based on user input. You MUST return only the command to be pasted and nothing more."
USER_MESSAGE="User input: $ARG"

# Escape special characters for JSON
ESCAPED_SYSTEM_MESSAGE=$(jq -Rs <<< "$SYSTEM_MESSAGE")
ESCAPED_USER_MESSAGE=$(jq -Rs <<< "$USER_MESSAGE")

REQUEST_BODY=$(jq -n --arg model "$MODEL" --arg system_message "$ESCAPED_SYSTEM_MESSAGE" --arg user_message "$ESCAPED_USER_MESSAGE" '
{
  model: $model,
  messages: [
    {role: "system", content: $system_message},
    {role: "user", content: $user_message}
  ]
}')

# Send request to OpenAI API
RESPONSE=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Extract and output the message from the response
MESSAGE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

# Remove double quotes if present
MESSAGE=$(echo "$MESSAGE" | sed 's/^"//' | sed 's/"$//')

# Output the command
echo -e "\n  COMMAND:\n\n  $MESSAGE\n"

# Prompt the user to ask if the message should be copied to the clipboard
read -p "Do you want to copy the command to the clipboard? [Y/n] " COPY_TO_CLIPBOARD
COPY_TO_CLIPBOARD=${COPY_TO_CLIPBOARD:-Y}

if [[ $COPY_TO_CLIPBOARD =~ ^[Yy]$ ]]; then
  # Copy the message to clipboard based on OS
  if command -v pbcopy &>/dev/null; then
    echo "$MESSAGE" | pbcopy
  elif command -v xclip &>/dev/null; then
    echo "$MESSAGE" | xclip -selection clipboard
  elif command -v xsel &>/dev/null; then
    echo "$MESSAGE" | xsel --clipboard --input
  elif command -v clip &>/dev/null; then
    echo "$MESSAGE" | clip
  else
    echo "No clipboard utility found. Please install xclip, xsel, pbcopy, or clip."
  fi
fi
