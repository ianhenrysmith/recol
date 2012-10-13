require 'watir-webdriver'

class Scraper
  attr_accessor :browser, :url, :sort_by
  SORTS = {"Date Listed" => "5"}
  
  def initialize(options={})
    super()
    @url = options[:url]
    @sort_by = "Date Listed"
  end
  
  def start(manual=false)
    @result = []
    @browser = Watir::Browser.new
    setup_scrape
    get_listings unless manual
  end
  
  def setup_scrape
    @browser.goto(@url)
    @browser.button(:id => 'btnsubmit').click
    @browser.select_list(:id, "mapsearch-sort-list").select(@sort_by)
  end
  
  def wait_for_listings
    sleep 1
    @browser.div(:class, 'listview-result').when_present.text
  end

  def next_page
    if @browser.link(:name, 'ms-results-next').exist?
      @browser.link(:name, 'ms-results-next').click
    else
      @browser.close
    end
  end

  def get_listings(options={})
    # need logic for ending search when:
    #   have already seen the rest of listings
    #   end of listings
  
    wait_for_listings
  
    listings = @browser.divs(:class, 'listview-result')
    listings.each do |listing|
      new_listing = Listing.new :text => listing.text
      if Listing.where(:mls => new_listing.mls).present?
        puts "existing listing -- #{new_listing.mls}"
      else
        puts new_listing.mls
        new_listing.save
        @result << new_listing.mls
      end
    end
    next_page
    get_listings(options)
  end
end