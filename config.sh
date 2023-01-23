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
