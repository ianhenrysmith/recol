require 'watir-webdriver'

class ScrapeController < ApplicationController
  def index
    browser = Watir::Browser.new
    browser.goto('http://recolorado.com')
    browser.button(:id => 'btnsubmit').click
    
    #wait until listings present
    browser.div(:class, 'listview-result').when_present.text
    
    listings = browser.divs(:class, 'listview-result')
    listings.each do |listing|
      lp = Listing.new :text => listing.text
      puts lp.mls
      
      # lp.save
    end
    
    browser.close
  end
end