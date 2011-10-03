#!/usr/bin/ruby
require "date"
require "fileutils"

dir = "/Users/alx/lifestream/archives/"
blank_color = "dark" # or "white"

Dir.glob(File.join(File.expand_path(dir), "*.jpeg")).each do |f|

  puts "file: #{f}"

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

  unless dir =~ /archives/
    FileUtils.mv f, File.join("..", "archives")
  end
end

#p "<html><body><table>"
#Dir.glob("*.jpeg").each{|file| p "<tr style='height:10px;width:10px;'><td style='background-color:#{`convert #{file} -resize 1x1\! txt:- | tail -1 | cut -f2 -d'#' | cut -f1 -d' '`}'></td></tr>"}
#p "</table></body></html>"
