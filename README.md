# LifeStream - Webcam Lifelapse

## Requirements

* homebrew: http://mxcl.github.com/homebrew/

## Installation

    git clone http://github.com/alx/lifestream
    cd lifestream
    brew install imagesnap
    cp lifestream.sh /usr/local/bin/
    launchctl load com.alexgirard.lifestream.plist
    mkdir -p ~/lifestream/archives/

## Calendar

Run:

    ruby calendar.rb
    open calendar/index.html

## Day to Day

Configure the script:

```
# Size of the mosaic to be generated in montage
tile_size = 20

# Source of webcam images
lifestream_archive = "/Users/alx/lifestream/archives/"

# Geometry of resized webcam images
geometry = "64x48"
```

Run to create montage files:

    ruby day_to_day.rb

Create a movie from montage files with ffmpeg:

    ffmpeg -r 10 -b 1800 -i day_to_day/montage_%03d.jpg test1800.mp4
