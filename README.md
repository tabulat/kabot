# kbot

A Telegram bot for determining time

## Features

- Allows you to find out the local time
- Simple and intuitive command interface

## Prerequisites

- Go 1.16 or later
- Telegram Bot Token (set as TELE_TOKEN environment variable)
- Required Go packages:
  - github.com/spf13/cobra
  - github.com/stianeikeland/go-rpio
  - gopkg.in/telebot.v4

## Installation

1. Clone the repository:
```bash
git clone https://github.com/tabulat/kabot.git
cd kbot
```

2. Set up your Telegram Bot Token:
```bash
export TELE_TOKEN="your_telegram_bot_token"
```

3. Build the application:
```bash
make build
```


## Usage

Start the bot:
```bash
./kbot start
```

### Available Commands

- `/start time` - Show local time
- `/start hello` - Get a greeting from the bot

## Development

The project uses Cobra for CLI command management.

### Project Structure

- `cmd/` - Contains the main command implementations
  - `kbot.go` - Main bot implementation and traffic light control
  - `root.go` - Root command configuration
  - `version.go` - Version command implementation

## Versioning

The application version is automatically generated during build using:
- Latest git tag
- Short commit hash

## License

This project is licensed under the MIT License - see the LICENSE file for details.
