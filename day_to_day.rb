#!/usr/bin/ruby
require "date"
require "fileutils"

def create_blank_images(date)
  color = "dark" # or white
  dest_dir =  File.join("day_to_day", "day-#{date.strftime("%j")}")
  unless File.exists?(dest_dir)
    FileUtils.mkdir_p(dest_dir)
    288.times do |image_index|
      f = File.join(dest_dir, "#{image_index}.jpg")
      `convert blank_#{color}.jpg -resize 64x48 #{f}` unless File.exists? f
    end
  end
end

def convert_to_day_images(dir)
  Dir.glob(File.join(File.expand_path(dir), "*.jpeg")).each do |f|

    # puts "file: #{f}"

    color = `convert #{f} -resize 1x1\! txt:- | tail -1 | cut -f2 -d'#' | cut -f1 -d' '`

    timestamp = File.basename(f).gsub("webcam_", "").gsub(".jpeg", "")
    date = DateTime.parse(Time.at(timestamp.to_i).to_s)

    create_blank_images(date)

    image_index = date.hour * 12 + (date.min / 5).to_i
    dest_image = File.join("day_to_day", "day-#{date.strftime("%j")}", "#{image_index}.jpg")

    `convert #{f} -resize 64x48 #{dest_image}` unless File.exists? dest_image
  end
end

def convert_to_frame
  days = Dir.glob(File.join(File.expand_path(dir), "day_to_day/*"))
end

convert_to_day_images "data"
