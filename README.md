# Notcot Swiper

A utility that pulls images down from notcot.org, updates the image EXIF info with the source and description of the image, and stores them in a folder for use with a screen saver or desktop wallpaper.  Works with OSX.

## Requirements

* OSX
* Exiftool (http://www.sno.phy.queensu.ca/~phil/exiftool/install.html#OSX)
* nokogiri gem
* mini_exiftool gem

## Usage

    ruby notcot-swiper.rb

Pass in `PICTURES_FOLDER` to change the local image destination.

## Thanks

* Notcot.org, of course, for their tasteful randomness
* Francis Hwang, who inspired this script with his wallpaper_swipe script (http://github.com/fhwang/wallpaper_swipe/tree)

## License

Copyright (c) Henry Poydar, released under the MIT license