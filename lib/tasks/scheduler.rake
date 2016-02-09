desc "Scrape for players"
task :scrape_yahoo => :environment do
  Rails.logger.debug "Scraping Players..."
  Scraper.call
  Rails.logger.debug "done."
end

desc "Fix attributes"
task :moar => :environment do
  AddMoreStats.call
end
