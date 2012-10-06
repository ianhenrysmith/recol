require 'watir-webdriver'

class ScrapeController < ApplicationController
  def index
    @result = []
    @browser = Watir::Browser.new
    @browser.goto('http://recolorado.com')
    @browser.button(:id => 'btnsubmit').click
    
    get_listings
    
    @browser.close
  end
  
  private
  # PROBABLY SHOULD MOVE THESE TO THE SCRAPER CLASS
  
  def wait_for_listings
    sleep 3
    @browser.div(:class, 'listview-result').when_present.text
  end
  
  def click_next
    @browser.link(:name, 'ms-results-next').click if @browser.link(:name, 'ms-results-next')
  end
  
  def get_listings(options={})
    # need logic for ending search when:
    #   have already seen the rest of listings
    
    wait_for_listings
    
    listings = @browser.divs(:class, 'listview-result')
    listings.each do |listing|
      new_listing = Listing.new :text => listing.text
      puts new_listing.mls
      unless Listing.where(:mls => new_listing.mls).present?
        new_listing.save
        @result << new_listing.mls
      end
    end
    click_next
    get_listings(options)
  end
end