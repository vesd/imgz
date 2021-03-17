#! /bin/bash

images=$(echo *.{png,PNG,jpg,JPG})

for image in $images
do
  # skip if filename starts with *
  if [[ `echo $image | cut -c1-1` == '*' ]]; then
    continue
  fi

  echo $image
done
