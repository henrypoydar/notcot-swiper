require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mini_exiftool'

def local_setup
  FileUtils.mkdir_p(PICTURES_FOLDER) unless File.exist?(PICTURES_FOLDER)
end

# This is some pretty brittle parsing, could use refactoring ... 
def process_feed
  images = []
  doc = Nokogiri::HTML(open(NOTCOT_FEED))
  doc.xpath('//entry').each do |entry|
    link = entry.search('link').first['href']
    id = link.split('/').last
    image_path = entry.search('content img').first['src']
    desc = entry.search('content').inner_text.split('(Want more?')[0].strip
    images << {:id => id, :link => link, :image_path => image_path, :description => desc}
  end
  images
end

# Assumes all images are JPEG
# Could use some error checking here
def process_images(images)
  adds, dupes = 0, 0
  images.each do |image|
    local_file = "#{image[:id]}.jpg"
    local_path = File.join(PICTURES_FOLDER, local_file)
    if File.exist?(local_path)
      dupes += 1
    else
      `curl -s -o #{local_path} #{image[:image_path]}`
      write_exif_comment(local_path, [image[:description], image[:link]].join(' '))
      adds += 1
    end
  end
  {:duplicates => dupes, :additions => adds}
end

def write_exif_comment(image_path, comment)
  photo = MiniExiftool.new(image_path)
  photo.keywords = ['notcot.org']
  photo['UserComment'] = comment
  photo.comment = comment
  photo.save
end

PICTURES_FOLDER = ENV['PICTURES_FOLDER'] || File.expand_path('~/Pictures/notcot.org')
NOTCOT_FEED = ENV['NOTCOT_FEED'] || 'http://www.notcot.org/atom.php'

local_setup
res = process_images(process_feed)
puts "#{res[:additions]} new images added"
