#! /bin/bash

getFormattedExifDateTime() {
  exif_date_time_original=`identify -verbose $1 | grep exif:DateTimeOriginal`

  # current format 2019:05:29 12:36:25
  # desired format 2019-05-29 12.36.25
  date_with_hyphens=`echo ${exif_date_time_original:27:10} | tr : -`
  time_with_dots=`echo ${exif_date_time_original:37} | tr : .`

  echo $date_with_hyphens $time_with_dots
}

getFormattedDate() {
  full_date=$1

  # current format 2021-01-16T19:00:17+02:00
  # desired format 2021-01-16 19.00.17
  date=`echo ${full_date:0:10}`
  time_with_dots=`echo ${full_date:11:8} | tr : .`
  echo $date $time_with_dots
}

getFormattedDateCreateOrModify() {
  create=`identify -verbose $1 | grep date:create`
  modify=`identify -verbose $1 | grep date:modify`

  date_create=${create:17}
  date_modify=${modify:17}

  if [[ $date_create<$date_modify ]]
  then
    formatted_date=$(getFormattedDate $date_create)
    suffix='(created)'
  else
    formatted_date=$(getFormattedDate $date_modify)
    suffix='(modified)'
  fi

  echo $formatted_date $suffix
}

purple=`tput setaf 5`
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`

images=$(echo *.{jpg,JPG,jpeg,JPEG,png,PNG})

echo ${green}Renaming started...${reset}

i=0
for orig_name in $images
do
  # skip if filename starts with *
  if [[ `echo $orig_name | cut -c1-1` == '*' ]]; then
    continue
  fi

  exif_date_time=$(getFormattedExifDateTime $orig_name)

  if [[ $exif_date_time ]]
  then
    date_time=$exif_date_time
  else
    date_time=$(getFormattedDateCreateOrModify $orig_name)
  fi

  echo ' ' Renaming ${purple}$orig_name${reset} to ${purple}${bold}$date_time $orig_name${reset}

  # rename file
  mv "$orig_name" "$date_time $orig_name"
  ((i+=1))
done

echo ${green}Renaming finished! ${bold}$i images renamed${reset}
