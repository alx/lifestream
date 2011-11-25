#!/usr/bin/ruby
require "date"
require "fileutils"

def create_blank_dates

  start_date = DateTime.new(2010, 1, 1)
  end_date = DateTime.new(2012, 1, 1)

  color = "dark" # or white

  dest_dir =  File.join("calendar", "pixel-days-#{color}")
  FileUtils.mkdir_p(dest_dir) unless File.exists?(dest_dir)

  while start_date < end_date
    f = File.join(dest_dir, "day-#{start_date.strftime("%F")}.jpg")
    unless File.exists? f
      FileUtils.cp "blank_#{color}.jpg", f
    end
    start_date += 1
  end
end

def convert_to_calendar_pixels
  dir = "~/lifestream/"
  blank_color = "dark" # or "white"

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
  end
end

def archive_images
    FileUtils.mv(f, File.expand_path("~/lifestream/archives/"))
end

create_blank_dates
convert_to_calender_pixels
archive_images
