#!/usr/bin/ruby
require "date"
require "fileutils"

## CONFIG

# Size of the mosaic to be generated in montage
tile_size = 20

# Source of webcam images
lifestream_archive = "/Users/alx/lifestream/archives/"

# Geometry of resized webcam images
geometry = "64x48"

## END CONFIG

def create_blank_images(date, geometry)
  color = "dark" # or white
  dest_dir =  File.join("day_to_day", "day-#{date.strftime("%Y-%j")}")
  unless File.exists?(dest_dir)
    p dest_dir
    FileUtils.mkdir_p(dest_dir)
    288.times do |image_index|
      f = File.join(dest_dir, "#{image_index}.jpg")
      `convert blank_#{color}.jpg -resize #{geometry}\! #{f}` unless File.exists? f
    end
  end
end

def convert_to_day_images(dir, geometry)
  Dir.glob(File.join(File.expand_path(dir), "*.jpeg")).each do |f|
    timestamp = File.basename(f).gsub("webcam_", "").gsub(".jpeg", "")
    date = DateTime.parse(Time.at(timestamp.to_i).to_s)

    create_blank_images date, geometry

    image_index = date.hour * 12 + (date.min / 5).to_i
    dest_image = File.join("day_to_day", "day-#{date.strftime("%Y-%j")}", "#{image_index}.jpg")
    p f + " - " + dest_image
    `convert #{f} -resize #{geometry}\! #{dest_image}`
  end
end

def convert_to_frame(tile_size)
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

    `montage #{images.join(" ")} -mode Concatenate -tile #{tile_size} -background black #{dest_image}`
  end
end

# Create resized images for each day
convert_to_day_images lifestream_archive, geometry

# Create frames for movie with 20x20 mosaic
convert_to_frame tile_size
