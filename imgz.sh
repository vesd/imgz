#!/usr/bin/env bash

set -euo pipefail

# Requires:
#   brew install exiftool
#
# Supports:
#   jpg jpeg png heic mov mp4
#
# Renames files like:
#   IMG_1234.HEIC
# ->
#   2024-03-18 14.22.09 IMG_1234.HEIC

purple=$(tput setaf 5)
green=$(tput setaf 2)
bold=$(tput bold)
reset=$(tput sgr0)

get_best_timestamp() {
    local file="$1"

    # Try several metadata fields in order
    # - DateTimeOriginal -> photos
    # - CreateDate -> general fallback
    # - MediaCreateDate -> videos
    #
    # -s3 = value only
    # -d  = output format directly from exiftool

    exiftool \
        -s3 \
        -d '%Y-%m-%d %H.%M.%S' \
        -DateTimeOriginal \
        -CreateDate \
        -MediaCreateDate \
        "$file" 2>/dev/null | head -n1
}

get_filesystem_timestamp() {
    local file="$1"

    # macOS stat format
    stat -f '%Sm' -t '%Y-%m-%d %H.%M.%S' "$file"
}

echo "${green}Renaming started...${reset}"

count=0

# Avoid literal *.jpg when no matches exist
shopt -s nullglob nocaseglob

for file in *.jpg *.jpeg *.png *.heic *.mov *.mp4
do
    [[ -f "$file" ]] || continue

    timestamp=$(get_best_timestamp "$file")

    if [[ -z "$timestamp" ]]; then
        timestamp=$(get_filesystem_timestamp "$file")
        suffix=" (filesystem)"
    else
        suffix=""
    fi

    new_name="${timestamp}${suffix} ${file}"

    # Skip if already renamed
    if [[ "$file" == "$new_name" ]]; then
        continue
    fi

    # Avoid overwriting files
    if [[ -e "$new_name" ]]; then
        echo " ${purple}Skipping${reset} ${file}"
        echo "   Target already exists: ${bold}${new_name}${reset}"
        continue
    fi

    echo " Renaming ${purple}${file}${reset}"
    echo "        -> ${purple}${bold}${new_name}${reset}"

    mv -- "$file" "$new_name"

    ((count+=1))
done

echo
echo "${green}Renaming finished! ${bold}${count} files renamed${reset}"
