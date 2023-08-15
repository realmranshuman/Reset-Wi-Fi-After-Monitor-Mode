#!/bin/bash
# This script will set wifi to managed mode, show the list of available networks with their SSID, and let the user choose one by number to connect to
# The password is asked in the script itself
# The temporary file is created in /tmp/
# The script will handle keyboard interrupt and delete the temporary files before exiting

# Define a function to handle keyboard interrupt
user_interrupt(){
  echo -e "\n\nKeyboard Interrupt detected."
  sleep 2
  echo -e "\nCleaning up..."
  rm -rf /tmp/cards.txt /tmp/networks.txt
  sleep 1
  echo "Exiting..."
  exit 1
}

# Set a trap to call the function when Ctrl-C is pressed
trap user_interrupt INT

# List the wifi cards and show them with numbers
echo "Available wifi cards:"
iw dev | grep Interface | cut -d " " -f2 > /tmp/cards.txt
num_cards=$(wc -l < /tmp/cards.txt)
awk '{print NR, $0}' /tmp/cards.txt

# Let the user choose a card by number
read -p "Enter the number of the wifi card you want to use: " choice

# Check if the choice is valid
if [ "$choice" -gt 0 ] && [ "$choice" -le "$num_cards" ]; then
  # Get the name of the chosen card
  card=$(sed "${choice}q;d" /tmp/cards.txt)
  echo "You chose $card"

  # Save the original name of the card
  orig_card=$card

  # Set wifi to managed mode
  sudo ip link set $card down
  sudo iw $card set type managed
  sudo ip link set $card up

  # Check if the name of the card has changed
  new_card=$(iw dev | grep Interface | cut -d " " -f2)
  if [ "$new_card" != "$orig_card" ]; then
    # Update the card variable with the new name
    card=$new_card
  fi

  # Restart network manager and wait for few seconds
  sudo systemctl restart NetworkManager
  echo "Waiting for the NetworkManager to start..."
  sleep 5

  # Check if the wifi card is scanning or not, if not, wait for it to scan
  scan_status=$(iwlist $card scan | grep Interface)
  while [ "$scan_status" = "Interface doesn't support scanning." ]; do
    echo "Waiting for wifi card to scan..."
    sleep 2
    scan_status=$(iwlist $card scan | grep Interface)
  done

  # Scan for available networks and show their SSID
  echo "Scanning for available networks..."
  sudo iwlist $card scan | grep ESSID > /tmp/networks.txt

  # Count the number of networks and show them with numbers
  num_networks=$(wc -l < /tmp/networks.txt)
  echo "Found $num_networks networks:"
  awk '{print NR, $0}' /tmp/networks.txt

  # Let the user choose a network by number
  read -p "Enter the number of the network you want to connect to: " choice

  # Check if the choice is valid
  if [ "$choice" -gt 0 ] && [ "$choice" -le "$num_networks" ]; then
    # Get the SSID of the chosen network
    ssid=$(sed "${choice}q;d" /tmp/networks.txt | cut -d '"' -f2)
    echo "You chose $ssid"

    # Ask for password if needed
    read -s -p "Enter password (leave blank if none): " password

    # Connect to the network using nmcli
    sudo nmcli dev wifi connect "$ssid" password "$password" ifname "$card"

    # Remove the temporary files after successful connection
    rm /tmp/cards.txt /tmp/networks.txt

    # Exit normally
    exit 0

  else
    # Invalid choice, exit with error message
    echo "Invalid choice, exiting..."
    exit 2
  fi

else
  # Invalid choice, exit with error message
  echo "Invalid choice, exiting..."
  exit 2
fi


