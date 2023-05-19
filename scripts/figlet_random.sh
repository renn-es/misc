#! /bin/bash
# Display "Renn.es" in ASCII with a random figlet font.
# This script can be used as a MOTD by adding its execution path to /etc/profile.


set -e


print_figlet() {

	figlet_output=$(figlet -f "$2" -t "$1")

	# Remove empty lines at start and end. Empty lines are lines with only spaces.
	figlet_output=$(echo "$figlet_output" | sed -e '/^[[:space:]]*$/d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' -e 's/\n*$//')

	# Add a vertical line and a space at the start and end of each line.
	figlet_output=$(echo "$figlet_output" | sed -e 's/^/│ /' -e 's/$/ │/')

	# Get the maximum line length.
	max_line_length=$(echo "$figlet_output" | awk '{ print length }' | sort -n | tail -n 1)

	dash_count=$((max_line_length - 2))
	dashes=$(printf "%${dash_count}s" | sed -e 's/ /─/g')
	dashes_and_box_drawings_top="┌$dashes┐"
	dashes_and_box_drawings_bottom="└$dashes┘"

	# If there are enough dashes, we can replace some in the middle with $3.
	# Else we just add that text before the figlet.
	[[ -n $3 ]] && {
		additional_text_length=${#3}
		if [[ $dash_count -ge $additional_text_length ]]; then
			dash_count=$((dash_count - additional_text_length))
			dashes=$(printf "%$((dash_count / 2))s" | sed -e 's/ /─/g')
			dashes_2=$(printf "%$((dash_count - dash_count / 2))s" | sed -e 's/ /─/g') # Needed because of rounding.
			dashes_and_box_drawings_top="┌$dashes$3$dashes_2┐"
		else
			figlet_output="$3\n$figlet_output"
		fi
	}

	# Add lines around the text.
	figlet_output=$(echo "$figlet_output" | sed -e "1s/^/$dashes_and_box_drawings_top\n/" -e "\$s/\$/\n$dashes_and_box_drawings_bottom/")
	echo "$figlet_output"
}


TEXT="Renn.es"
FONTS="larry3d lean kban gothic basic coinstak cosmic fender fraktur speed"

# Pick a random font from the list.
random_font=$(echo "$FONTS" | tr ' ' '\n' | shuf -n 1)

# Display the binary font instead with a 1/10000 chance.
if [ $((RANDOM % 1000)) -eq 0 ]; then
	random_font="binary"
fi

print_figlet "$TEXT" "$random_font" "Welcome to"


# FONTS=$(find /usr/share/figlet/fonts/ -type f -name "*.flf" | sed -e 's/.flf//g' | tr '\n' ' ')


# for font in $FONTS; do
# 	echo "$font"
# 	print_figlet "$TEXT" "$font" "Welcome to"
# done
