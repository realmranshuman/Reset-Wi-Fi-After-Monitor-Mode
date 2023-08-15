# Script To Disable Monitor Mode & Enable Managed Mode

This Bash script is designed to assist ethical hackers in transitioning their WiFi card from monitor mode to managed mode after monitoring, sniffing, or related activities. It offers an interactive menu that allows you to select a WiFi card, choose an available network, and connect to it using NetworkManager. Additionally, the script handles interruptions and ensures proper cleanup.

## Prerequisites

- Linux operating system
- Bash shell
- NetworkManager
- `iw` and `iwlist` commands (usually provided by the `iw` package)

## Usage

1. Make sure you have the necessary permissions to run the script (e.g., execute permission).
2. Open a terminal and navigate to the directory containing the script.
3. Execute the script: `./ManagedMode-Wi-Fi.sh`

## Features

- Lists available WiFi cards and lets you choose one.
- Sets the chosen WiFi card to managed mode.
- Restarts NetworkManager to ensure proper functioning.
- Scans for available networks and displays their SSIDs.
- Prompts you to select a network to connect to.
- Asks for a password if required and attempts to connect.
- Handles keyboard interruptions gracefully and performs cleanup.

## How it works

1. The script begins by listing available WiFi cards. You choose a WiFi card by entering its corresponding number.
2. The chosen WiFi card is set to managed mode using the `ip` and `iw` commands.
3. NetworkManager is restarted to apply changes.
4. The script scans for available networks and displays their SSIDs. You select a network by entering its number.
5. If the network requires a password, you can enter it securely.
6. The script uses `nmcli` to attempt to connect to the chosen network.
7. Upon successful connection, the temporary files containing card and network information are deleted.
8. If you interrupt the script with Ctrl-C, it cleans up temporary files and exits gracefully.

## Notes

- This script assumes that you have the necessary permissions to run commands with `sudo`.
- It's recommended to verify the script against your system's configuration before use.
- Use this script responsibly and for ethical purposes only.

## Acknowledgments

This script was developed to simplify the process of transitioning WiFi cards from monitor mode to managed mode after monitoring activities. Feel free to modify and enhance it according to your needs.

## Disclaimer

This script is provided as-is, without any warranties or guarantees. Use it at your own risk. The author is not responsible for any misuse or consequences resulting from using this script.

If this script helped you, subscribe to my YouTube channel [@realmranshuman](https://youtube.com/realmranshuman?sub_confirmation=1).