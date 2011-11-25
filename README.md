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
