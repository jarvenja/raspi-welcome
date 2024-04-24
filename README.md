# raspi-welcome

This (welcome.sh) is my default welcome message especially for Raspberry Pi devices. The script provides useful information and can help prevent confusion or misremembering some things when using multiple similar devices. It also shows the temperature in Raspberry Pi devices, which can unexpectedly rise when the load is increased, for example due to the wrong type of case.

## Routines

The script contains the following routines:
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

To customize the default ASCII art just provide some text file path as only parameter.

><><>< raspi-welcome v0.2 beta
usage: welcome.sh ascii-art-file

### Raspberry OSes

The script is tested on Raspberry Pi Model B Rev 2.

(image)

### Linux Mint

The script works also on most other Linux-gnu distros. Since supported commands varies a little the result information is also a bit different.

(image)
