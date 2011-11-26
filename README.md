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

Run to create montage files:

  ruby day_to_day.rb

Create a movie from montage files with ffmpeg:

  mpeg -r 10 -b 1800 -i montage_%03d.jpg test1800.mp4
