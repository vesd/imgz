# imgz
Shell script for prefixing file names of images with their creation dates

## Problem
The [identify](https://linux.die.net/man/1/identify) command describes the format and characteristics of one or more image files.
E.g., running `identify -verbose IMG_8627.jpg` returns:

```bash
Image: IMG_8627.jpg
  Format: JPEG (Joint Photographic Experts Group JFIF format)
  ...
  Properties:
    date:create: 2021-03-16T21:45:53+02:00
    date:modify: 2018-06-25T21:37:08+03:00 # using the smallest of the two as a fallback if `exif:DateTimeOriginal` is missing
    exif:ApertureValue: 2159/1273
    exif:BrightnessValue: 3449/5915
    exif:ColorSpace: 65535
    exif:ComponentsConfiguration: 1, 2, 3, 0
    exif:DateTime: 2018:06:25 18:30:46
    exif:DateTimeDigitized: 2018:06:25 18:30:46
    exif:DateTimeOriginal: 2018:06:25 18:30:46 # this is the value we're interested in, but not all images have it
    ...
  ...
```
