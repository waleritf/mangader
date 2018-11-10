require 'nokogiri'
require 'open-uri'
require 'net/http'

class Mangader
  HOST = 'http://mangareader.xyz'

  attr_reader :manga

  def initialize(manga)
    @manga = manga
  end

  def download
    puts('Folder creating...')
    Dir.mkdir(main_dir) unless Dir.exist?(main_dir)

    puts('Chapters fetching...')
    chapters.each do |chapter|
      download_chapter(chapter)
    end

    puts 'Finished'
    return true
  end

  private

  def download_chapter(chapter)
    chapter_name = chapter.split('/').last
    puts(chapter_name + '...')
    page = 1

    while true
      print("-#{page}-")
      chapter_url = File.join(HOST, chapter, "?page=#{page}")
      chapter_page = Nokogiri::HTML(open(chapter_url).read)
      img = chapter_page.css('section#view-chapter img')

      break if img.empty?

      file = Net::HTTP.get(URI(img.attr('src').value))
      chapter_dir = File.join(main_dir, chapter_name)
      file_path = File.join(main_dir, chapter_name, "#{page}.jpg")
      Dir.mkdir(chapter_dir) unless Dir.exist?(chapter_dir)
      File.open(file_path, 'wb') { |f| f << file }
      page += 1
    end
  end

  def chapters
    init_url = File.join(HOST, manga, 'chapter-1')
    page = Nokogiri::HTML(open(init_url).read)
    page.css('.select-chapter select option').map { |o| o.attr('value') }
  end

  def main_dir
    File.join(Dir.home, manga)
  end
end
