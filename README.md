# Shelper

## Overview

Shelper (Shell + Helper) is a command-line tool that provides terminal commands based on user input optimized for MacOS. It uses OpenAI's GPT-XX model to generate commands and can execute the generated command.

## Install

1. Make the install script executable:
   ```sh
   chmod +x ./install.sh
   ```

2. Run the install script:
   ```sh
   ./install.sh
   ```

   During the installation, you will be prompted to enter your OpenAI API key. The script will also add the installation directory to your PATH if it's not already there.

## Update Configuration

If you need to update your API key, run the configuration script:

1. Make the config script executable:
   ```sh
   chmod +x ./config.sh
   ```

2. Run the config script:
   ```sh
   ./config.sh
   ```

## Uninstall

1. Make the uninstall script executable:
   ```sh
   chmod +x ./uninstall.sh
   ```

2. Run the uninstall script:
   ```sh
   ./uninstall.sh
   ```

   This will remove the `shelper` symlink and the configuration file located at `~/.shelper_config`.

## Usage

Run the script from any terminal:
```sh
shelper <your query>
```

For example:
```sh
shelper List all files in a directory
```

### Run command

After the command is generated, you will be prompted to execute the command.

### Example

```sh
$ shelper Create a new directory named 'testdir'

  COMMAND:

  mkdir testdir

Do you want to execute the command? [Y/n]
``` -->

<!-- ### Clipboard Copy

After the command is generated, you will be prompted to copy the command to the clipboard. The script supports the following clipboard utilities:

- `pbcopy` (macOS)
- `xclip` (Linux)
- `xsel` (Linux)
- `clip` (Windows)

If no clipboard utility is found, the script will notify you to install one of the supported utilities.

### Example

```sh
$ shelper Create a new directory named 'testdir'

  COMMAND:

  mkdir testdir

Do you want to copy the command to the clipboard? [Y/n]
``` -->

## Development

### Repository Structure

```
shelper/
├── README.md
├── bin/
│   └── shelper.sh
├── install.sh
├── uninstall.sh
├── config.sh
├── .gitignore
```

### bin/shelper.sh

__Variables__

`MODEL` - Choose the OpenAPI model to use
`SYSTEM_MESSAGE` - The system input establishing context for user input

## TODOs

- [ ] User input edge cases
- [ ] OS compatibility (only tested on MacOS)
- [ ] Install compatibility
- [ ] Include operating system in the system prompt
- [ ] Consider first argument switch that uses different prompts

## Contributions
Feel free to contribute to this project by opening issues or submitting pull requests.

## Contact
For any questions or feedback, please contact [your email or other contact information].
