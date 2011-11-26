#!/usr/bin/ruby
require "date"
require "fileutils"

def create_blank_images(date)
  color = "dark" # or white
  dest_dir =  File.join("day_to_day", "day-#{date.strftime("%Y-%j")}")
  unless File.exists?(dest_dir)
    p dest_dir
    FileUtils.mkdir_p(dest_dir)
    288.times do |image_index|
      f = File.join(dest_dir, "#{image_index}.jpg")
      `convert blank_#{color}.jpg -resize 64x48\! #{f}` unless File.exists? f
    end
  end
end

def convert_to_day_images(dir)
  Dir.glob(File.join(File.expand_path(dir), "*.jpeg")).each do |f|
    timestamp = File.basename(f).gsub("webcam_", "").gsub(".jpeg", "")
    date = DateTime.parse(Time.at(timestamp.to_i).to_s)

    create_blank_images(date)

    image_index = date.hour * 12 + (date.min / 5).to_i
    dest_image = File.join("day_to_day", "day-#{date.strftime("%Y-%j")}", "#{image_index}.jpg")
    p f + " - " + dest_image
    `convert #{f} -resize 64x48\! #{dest_image}`
  end
end

def convert_to_frame
  days = Dir.glob("day_to_day/day-*")
  288.times do |image_index|
    p "montage #{image_index}"
    images = days.map do |dir|
      File.join(dir, "#{image_index}.jpg")
    end

    dest_image = "day_to_day/montage_#{image_index}.jpg"
    if image_index < 10
      dest_image = "day_to_day/montage_00#{image_index}.jpg"
    elsif image_index < 100
      dest_image = "day_to_day/montage_0#{image_index}.jpg"
    end

    `montage #{images.join(" ")} -mode Concatenate -tile x20 -background black #{dest_image}`
  end
end

#convert_to_day_images "/Users/alx/lifestream/archives/"
convert_to_frame
