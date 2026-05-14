# imgz
A shell script for prefixing file names of images with their creation dates.
As a result, a generic `IMG_4325.JPG` will become a more descriptive `2011-04-29 23.41.56 IMG_4325.JPG`.

## Prerequisites
`brew install exiftool`

## How to use
- make the script executable: `chmod +x imgz.sh`
- copy photos to the same folder where the `imgz.sh` script file is
- in terminal, navigate to the folder
- run the script: `./imgz.sh`
