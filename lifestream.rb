#!/usr/bin/ruby

require 'Date'
require 'FileUtils'

class JPEG
  attr_reader :width, :height, :bits

  def initialize(file)
    if file.kind_of? IO
      examine(file)
    else
      File.open(file, 'rb') { |io| examine(io) }
    end
  end

private
  def examine(io)
    raise 'malformed JPEG' unless io.getc == 0xFF && io.getc == 0xD8 # SOI

    class << io
      def readint; (readchar << 8) + readchar; end
      def readframe; read(readint - 2); end
      def readsof; [readint, readchar, readint, readint, readchar]; end
      def next
        c = readchar while c != 0xFF
        c = readchar while c == 0xFF
        c
      end
    end

    while marker = io.next
      case marker
        when 0xC0..0xC3, 0xC5..0xC7, 0xC9..0xCB, 0xCD..0xCF # SOF markers
          length, @bits, @height, @width, components = io.readsof
          raise 'malformed JPEG' unless length == 8 + components * 3
        when 0xD9, 0xDA:  break # EOI, SOS
        when 0xFE:        @comment = io.readframe # COM
        when 0xE1:        io.readframe # APP1, contains EXIF tag
        else              io.readframe # ignore frame
      end
    end
  end
end

def convert_montage_to_video
  
  lifestream_root = "/Users/alx/lifestream/"
  image_files = File.join(lifestream_root, "images", "*.jpeg")
  montage_root = File.join(lifestream_root, "montage")
  blank_file = File.join(lifestream_root, "blank.jpg")
  
  incremental = 0
  previous_timestamp = ""
  
  # Clean invalid files
  Dir.glob(image_files).select{|file| JPEG.new(file).width != 1760}.each{|file| File.unlink file}
  
  Dir.glob(image_files).each do |file|
    
    timestamp = file[/\d+/]
    
    diff = timestamp[0..-3].to_i - previous_timestamp[0..-3].to_i
    if previous_timestamp.empty? || diff == 3
      FileUtils.mv(file, File.join(montage_root, "#{"%05d" % incremental}.jpg"))
      incremental += 1
    else
      (diff / 3).times do |i|
        FileUtils.cp(blank_file, File.join(montage_root, "#{"%05d" % incremental}.jpg"))
        incremental += 1
      end
    end
    previous_timestamp = timestamp
  end
  
  # Convert images into videos using ffmpeg
  current_week = Date.today.cweek
  output = File.join(lifestream_root, "video/lifestream_#{current_week}.mp4")
  `cd #{montage_root}; /opt/local/bin/ffmpeg -r 20 -b 1800 -i %05d.jpg #{output}`
  
  # Remove montage files
  Dir.glob(File.join(montage_root,"*.jpg")).each{|file| File.unlink file}
  Dir.glob(image_files).each{|file| File.unlink file}
end

convert_montage_to_video