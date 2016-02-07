desc "Scrape for players"
task :scrape_yahoo => :environment do
  Rails.logger.debug "Scraping Players..."
  Scraper.call
  Rails.logger.debug "done."
end
