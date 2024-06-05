#!/bin/bash

# Initialize variables
MODEL="gpt-4" # or any other model you want to use
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


# Define color codes
# POP='\033[0;31m' # red
POP='\033[1;34m' # blue
NC='\033[0m' # No Color

# Output the command
echo -e "\n  COMMAND:\n\n  ${POP}${MESSAGE}${NC}\n"

# Prompt the user to ask if the message should be executed
read -p "Do you want to execute the command? [Y/n] " EXECUTE_COMMAND
EXECUTE_COMMAND=${EXECUTE_COMMAND:-Y}

if [[ $EXECUTE_COMMAND =~ ^[Yy]$ ]]; then
  # Execute the command
  eval $MESSAGE
  
  # if ~/.zsh_history exists, append the command to it
  if [ -f "$HOME/.zsh_history" ]; then
    echo "$MESSAGE" >> "$HOME/.zsh_history"
  fi

  # if ~/.bash_history exists, append the command to it
  if [ -f "$HOME/.bash_history" ]; then
    echo "$MESSAGE" >> "$HOME/.bash_history"
  fi
fi


# Prompt the user to ask if the message should be copied to the clipboard
# read -p "Do you want to copy the command to the clipboard? [Y/n] " COPY_TO_CLIPBOARD
# COPY_TO_CLIPBOARD=${COPY_TO_CLIPBOARD:-Y}

# if [[ $COPY_TO_CLIPBOARD =~ ^[Yy]$ ]]; then
#   # Copy the message to clipboard based on OS
#   if command -v pbcopy &>/dev/null; then
#     echo "$MESSAGE" | pbcopy
#   elif command -v xclip &>/dev/null; then
#     echo "$MESSAGE" | xclip -selection clipboard
#   elif command -v xsel &>/dev/null; then
#     echo "$MESSAGE" | xsel --clipboard --input
#   elif command -v clip &>/dev/null; then
#     echo "$MESSAGE" | clip
#   else
#     echo "No clipboard utility found. Please install xclip, xsel, pbcopy, or clip."
#   fi
# fi
