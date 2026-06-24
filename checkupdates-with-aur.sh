#!/usr/bin/env bash

# checkupdates-with-aur version 2.1.0
# Copyright (C) 2026 SakuSnack
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Get environment variable, set to 1 by default if not already set
PRINT_UPDATE_COUNT="${PRINT_UPDATE_COUNT:-1}"

# Check for argument and modify environment variable if argument is present
if case "$@" in *--no-count*) true ;; *-n*) true ;; *) false ;; esac then
	PRINT_UPDATE_COUNT=0
fi

# Set up formatting escape sequences
normal="\033[0m"
bold="\033[0;1m"
green="\033[1;32m"
yellow="\033[1;33m"

# Get updates via pacman and aur vercmp, store them into temporary files so we can parallelize it
# Since we are parallelizing it, whichever finished first would print first, so we handle printing later
# In the desired order (AUR last for consistency)
pacman -Qm | aur vercmp >/tmp/checkupdates-aur.$$ &
checkupdates >/tmp/checkupdates-repo.$$ &
wait

# Read AUR packages from temp file (to format later)
aurPKGswithUpdate=$(cat /tmp/checkupdates-aur.$$)

# Print repo updates, as they are already formatted as desired
cat /tmp/checkupdates-repo.$$

# If AUR updates are available, print them
if [[ ! -z $aurPKGswithUpdate ]]; then
	# We read one line at a time (in variable $string); file is specified after "done"
	while read -r string; do
		# Separate line into elements separated by string
		IFS=' ' read -r name versionLocal arrow versionRemote <<<"$string"
		# Print formatted string
		echo -e "${yellow}AUR: ${bold}$name ${green}$versionLocal${normal} $arrow ${green}$versionRemote${normal}"
	done <<<"$aurPKGswithUpdate"
fi

#Print update count, if desired
if [[ $PRINT_UPDATE_COUNT -eq 1 ]]; then
	# Count amount of updates
	numPackagesRepo=$((0 + $(wc -l /tmp/checkupdates-repo.$$ | cut -d' ' -f1)))
	numPackagesAUR=$((0 + $(wc -l /tmp/checkupdates-aur.$$ | cut -d' ' -f1)))
	numPackagesTotal=$((0 + numPackagesRepo + numPackagesAUR))

	# Only print anything if there are updates
	if [[ $numPackagesTotal -gt 0 ]]; then
		# Empty line after the last package for a cleaner look
		printf "\n"

		# Print repo and AUR update count separately, if applicable
		if [[ $numPackagesRepo -gt 0 ]] && [[ ! $numPackagesRepo -eq $numPackagesTotal ]]; then
			echo -e "${bold}Repo updates:\t${green}$numPackagesRepo${normal}"
			echo -e "${bold}AUR updates:\t${green}$numPackagesAUR${normal}"
		fi

		# Print total update count
		echo -e "${bold}Total updates:\t${green}$numPackagesTotal${normal}"
	fi
fi

# Clean up temporary files
rm -f /tmp/checkupdates-{aur,repo}.$$
