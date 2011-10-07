#!/usr/bin/ruby
require "date"
require "fileutils"


dir = "~/lifestream/"
blank_color = "dark" # or "white"
archive = true # or not

Dir.glob(File.join(File.expand_path(dir), "*.jpeg")).each do |f|

  # puts "file: #{f}"

  color = `convert #{f} -resize 1x1\! txt:- | tail -1 | cut -f2 -d'#' | cut -f1 -d' '`

  timestamp = File.basename(f).gsub("webcam_", "").gsub(".jpeg", "")
  date = DateTime.parse(Time.at(timestamp.to_i).to_s)

  output = File.join("calendar", "pixel-days-#{blank_color}", "day-#{date.strftime('%F')}.jpg")
  FileUtils.cp("blank_#{blank_color}.jpg", output) unless File.exists?(output)

  minutes = date.min
  while(minutes%5 != 0)
    minutes -= 1
  end
  pixel_x = minutes / 5

  pixel_y = date.hour

  `convert #{output} -fill '##{color}' -draw 'color #{pixel_x},#{pixel_y} point' #{output}`

  FileUtils.mv(f, File.expand_path("~/lifestream/archives/")) if archive
end
