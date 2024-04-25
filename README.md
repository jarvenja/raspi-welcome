# raspi-welcome

A "welcome script" typically refers to a script or program that is automatically executed when a user logs into a computer system or a specific user account. Its purpose is to provide a personal or informative welcome message, define the user environment or perform other tasks to improve the user experience.

This script (welcome.sh) tries to provide the user with a basic set of information about a Linux-based server, especially Raspberry Pi devices, when they are in the "construction phase". It helps prevent confusion or misremembering some things when working with many devices of the same type. It shows, for example, the temperature of the Raspberry Pi device, which can unexpectedly rise when the load is increased, for example due to insufficient cooling of the case.

## Functions

The welcome script includes the following functions:
- checks internet connection when connected locally
- displays CPU temperature (Raspberry OS only)
- displays CPU architecture
- displays SBC (Single-board computer) or CPU model
- displays current local time
- displays ASCII art
- displays OS version
- displays if bluetooth adapter is up or found
- displays screen/windows size in characters
- shows if specific commands are installed or not

## Usage

1) Copy the script into your user script directory
2) Call it at the end of ~/.bashrc file to run it each time you login

### Parameters

To change the default ASCII art into your own just provide the correct path to text file as only parameter.

><><>< raspi-welcome v0.2 beta
usage: welcome.sh ascii-art-file

### Raspberry OSes

The script is tested on Raspberry Pi Model B Rev 2. Here is what it looks like:

![Welcome RPi](snapshots/welcome-rpi.png?raw=true "Running welcome.sh on Raspberry Pi")

### Linux Mint

The script works also on most Linux-gnu versions. Here is what it looks like on Linux Mint:

![Welcome Mint](snapshots/welcome-mint.png?raw=true "Running welcome.sh on Linux Mint 21.3")

Since supported commands varies a little the provided information differs.

Thats it. You welcome!
