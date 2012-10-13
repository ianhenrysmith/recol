class ScrapeJob < Struct.new(:url)
  def perform
    s = Scraper.new(:url => url)
    s.start
  end
end