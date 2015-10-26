require 'open-uri'
require 'pry'
require 'pry-nav'
require 'nokogiri'

class Search

  attr_accessor :min, :max, :links

  def initialize(min, max)
    @min = min
    @max = max
    @links = []
  end

  def url(index)
    "http://newyork.craigslist.org/search/aap/brk?s=#{paginate(index)}catAbb=aap&query=&minAsk=#{min.to_s}&maxAsk=#{max.to_s}&bedrooms=2&housing_type=1&excats="
  end

  def paginate(index)
    (index * 100).to_s
  end

  def run
    (1..25).each do |index|
      doc = Nokogiri::HTML(open(url(index)))
      get_links(doc)
      persist
      links.clear
      puts "saved links #{index}-#{index * 100}"
    end
  end

  def get_links(doc)
    doc.css(".row .pl").each_with_index do |node, index|
      bedrooms = parse_bedroom(index, doc)
      if bedrooms.to_i > 2
        puts "skipping because bedrooms #{bedrooms}"
        next
      end
      if Apartment.exists?(:description => parse_description(node))
        puts "skipping because exists"
        next
      end
      href = parse_href(index,node)
      image_url = get_image(href)
      if image_exists?(image_url, links)
        puts "image exists so skipping"
        next
      end
      links << {:href => href,
       :price => parse_price(index, doc),
       :location => parse_location(index, doc),
       :bedrooms => bedrooms,
       :description => parse_description(node),
       :image_url => image_url
     }
    end
  end

  def image_exists?(image_url, links)
    links.collect {|link| link[:image_url]}.include?(image_url)
  end

  def format_url(href)
    "http://newyork.craigslist.org#{href}"
  end

  def get_image(href)
    doc = Nokogiri::HTML(open(format_url(href)))
    parse_image_url(doc)
  end

  def parse_image_url(doc)
    image_url = ""
    image = doc.css("[title~='image 1']")
    if image.present?
      image_url = image.first.attributes['src'].value
    end
    image_url
  end

  def parse_description(node)
    node.children[3].children[0].text
  end

  def parse_href(index, node)
    # node.children[2].attributes["href"].value
    node.children[3].attributes["href"].value
  end

  def parse_price(index, doc)
    doc.css(".row .l2")[index].children[1].children.first.text[1..-1].to_i
  end

  def parse_location(index, doc)
    remove_crud(doc.css(".row .l2")[index].children[5].children[1].children[0].text)
  end

  def remove_crud(location)
    location.gsub("(", "").gsub(")","").strip
  end

  def parse_bedroom(index, doc)
    # node.children[7].children[2].text.match(/\d\w{2}/)[0]
    doc.css(".row .l2")[index].children[3].children[0].text.match(/\d\w{2}/)[0]
  end

  def persist
    links.each do |link|
      Apartment.create(link)
    end
  end

end

# search = Search.new
# search.run