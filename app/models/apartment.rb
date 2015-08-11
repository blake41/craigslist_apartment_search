class Apartment < ActiveRecord::Base
  attr_accessible :bedrooms, :href, :location, :price, :description, :image_url
  
  LOCATIONS = ["Carroll Gardens", "Cobble Hill", "Boerum Hill", "brooklyn heights"] 
  
  def self.good
    Apartment.where(:location => find_good_hoods).order("created_at DESC")
  end

  def self.old_good
    Apartment.where(:location => LOCATIONS)
  end

  def self.find_good_hoods
    good_hoods = []
    Apartment.find_by_sql("select distinct location from apartments").collect {|a|a.location}.each do |hood|
      match = hood.match(create_regex)
      good_hoods << match.to_s if match
    end
    good_hoods
  end

  def self.create_regex
    Regexp.new(LOCATIONS.collect{|location| ".*#{location.gsub(" ", ".*")}.*"}.join("|"), "i")
  end

  def formatted_url
    "http://newyork.craigslist.org/#{self.href}"
  end
end
