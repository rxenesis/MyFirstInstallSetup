#!/bin/bash

function isRoot() {
	if [ "$EUID" -ne 0 ]; then
		return 1
	fi
}

function checkOS() {
	if [[ -e /etc/arch-release ]]; then
		OS=arch
	else
		echo "Looks like you aren't running this installer on a Debian, Ubuntu or Arch Linux system"
		exit 1
	fi
}

function initialCheck() {
	if ! isRoot; then
		echo "Sorry, you need to run this as root"
		exit 1
	fi
	checkOS
}


function installMidiFix() {
	if [[ $OS == 'arch' ]]; then
		# Install required dependencies and upgrade the system
		# https://github.com/frescobaldi/frescobaldi/wiki/MIDI-playback-on-Linux
		sudo pacman --needed --noconfirm -Syu portmidi fluidsynth soundfont-fluid
		sudo dd if=/dev/null of=/etc/conf.d/fluidsynth
		echo "# Mandatory parameters (uncomment and edit)
SOUND_FONT=/usr/share/soundfonts/FluidR3_GM.sf2

# Additional optional parameters (may be useful, see 'man fluidsynth' for further info)
OTHER_OPTS='-a alsa -m alsa_seq -i -l -s -p FluidSynth -R 0 -C 0 -c 2 -z 512 -r 48000 -g 4'" | 
sudo tee -a /etc/conf.d/fluidsynth
		systemctl --user daemon-reload
		systemctl --user start fluidsynth.service
		systemctl --user enable fluidsynth.service
		if (pacman -Qs frescobaldi >/dev/null) ; then 
			sudo pacman --needed --noconfirm -Syu frescobaldi
		fi
	fi
}

function installTools() {
	if [[ $OS == 'arch' ]]; then
		# Install required dependencies and upgrade the system
		sudo pacman --needed --noconfirm -Syu bitwarden nano  gedit signal-desktop
		sudo pacman --needed --noconfirm -Syu kodi kodi-addon-pvr-iptvsimple
	fi
}

function installFixBluetooth() {
	if [[ $OS == 'arch' ]]; then
		# Install required dependencies and upgrade the system
		# https://hazlolinux.com/bluetooth/como-configurar-bluetooth-en-arch-linux/
		# sudo nano /etc/bluetooth/main.conf; sudo rfkill list; 
		sudo pacman --needed --noconfirm -Syu bluez bluez-utils blueman
		sudo rfkill unblock bluetooth
		sudo systemctl start bluetooth.service
		sudo systemctl enable bluetooth.service
	fi
}

#initialCheck
checkOS
#installOneshot
installMidiFix
