# checkupdates-with-aur for Arch Linux
Helper script to check updates, including AUR updates, nicely formatted

### What this script does
This script first runs ``checkupdates`` and ``pacman -Qm | aur vercmp`` in parallel, then prints the results in a nice format matching the usual checkupdates results, along with total update count (optional).

###### With update count:

![Screenshot with count](/res/screenshot-with-count.png?raw=true "Screenshot with count")

###### Without update count:
![Screenshot without count](/res/screenshot-without-count.png?raw=true "Screenshot without count")

### How to install
Clone the repository, cd into it, run makepkg

```
git clone https://github.com/SakuSnack/checkupdates-with-aur
cd checkupdates-with-aur
makepkg -si
```
The script will then be installed as ``/usr/bin/checkupdates-with-aur`` and be usable from any shell.

Alternatively, you can also use the script without installing it (however, the packages ``pacman-contrib`` and ``aurutils`` are required:
```
sudo pacman -S --needed pacman-contrib aurutils
./checkupdates-with-aur.sh
```

Options:
```
--no-count    -n  Skip printing the number of updated packages
```
Environment variables:
```
PRINT_UPDATE_COUNT=0    Skip printing the number of updated packages
```

## Disclaimer
I provide this script as is with no warranty, as mentioned in the [LICENSE](LICENSE)
