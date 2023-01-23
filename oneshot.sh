source config.sh

function installOneshot() {
	if [[ $OS == 'arch' ]]; then
		# Install required dependencies and upgrade the system
		sudo pacman --needed --noconfirm -Syu wpa_supplicant pixiewps wget python
		find /home/ -maxdepth 2 -name "oneshot.py" -delete
		find /home/ -maxdepth 2 -name "vulnwsc.txt" -delete
		wget https://raw.githubusercontent.com/drygdryg/OneShot/master/oneshot.py
		wget https://raw.githubusercontent.com/drygdryg/OneShot/master/vulnwsc.txt
	fi
}

checkOS
installOneshot
