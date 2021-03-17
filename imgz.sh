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

images=$(echo *.{jpg,JPG,jpeg,JPEG,png,PNG})

for image in $images
do
  # skip if filename starts with *
  if [[ `echo $image | cut -c1-1` == '*' ]]; then
    continue
  fi

  exif_date_time=$(getFormattedExifDateTime $image)

  if [[ $exif_date_time ]]
  then
    date_time=$exif_date_time
  else
    date_time=$(getFormattedDateCreateOrModify $image)
  fi

  echo $date_time
done
