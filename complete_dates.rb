#!/usr/bin/ruby
require "date"
require "fileutils"

start_date = DateTime.new(2010, 1, 1)
end_date = DateTime.new(2012, 1, 1)

color = "dark" # or white
color = "white"

while start_date < end_date
  f = File.join("calendar", "pixel-days-#{color}", "day-#{start_date.strftime("%F")}.jpg")
  unless File.exists? f
    FileUtils.cp "blank_#{color}.jpg", f
  end
  start_date += 1
end
