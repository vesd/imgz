#! /bin/bash

getExifDateTimeOriginal() {
  date_time_original=`identify -verbose $1 | grep exif:DateTimeOriginal`

  echo ${date_time_original:27}
}

getDateCreateOrModify() {
  create=`identify -verbose $1 | grep date:create`
  modify=`identify -verbose $1 | grep date:modify`

  date_create=${create:17}
  date_modify=${modify:17}

  if [[ $date_create<$date_modify ]]
  then
    echo DateCreate: $date_create
  else
    echo DateModify: $date_modify
  fi
}

images=$(echo *.{jpg,JPG,jpeg,JPEG,png,PNG})

for image in $images
do
  # skip if filename starts with *
  if [[ `echo $image | cut -c1-1` == '*' ]]; then
    continue
  fi

  date_time_original=$(getExifDateTimeOriginal $image)

  if [[ $date_time_original ]]
  then
    echo ExifDateTimeOriginal: $date_time_original
  else
    date_create_or_modify=$(getDateCreateOrModify $image)
    echo $date_create_or_modify
  fi
  
done
