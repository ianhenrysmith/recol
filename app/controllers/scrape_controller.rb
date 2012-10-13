class ScrapeController < ApplicationController
  def index
    Delayed::Job.enqueue ScrapeJob.new("http://recolorado.com")
    @result = true
  end
end