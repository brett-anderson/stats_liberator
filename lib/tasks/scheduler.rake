desc "Scrape for players"
task :scrape_yahoo => :environment do
  Rails.logger.debug "Scraping Players..."
  Scraper.call
  Rails.logger.debug "done."
end

desc "Fix attributes"
task :build_attrs => :environment do
  Rails.logger.debug "Fixing Players..."
  Player.where(height: nil ).find_in_batches(batch_size: 5) do |player_batch|
    player_batch.each do | player |
      Rails.logger.debug "Fixing #{player.name}"
      player.generate_columns_from_html
      player.save
    end
  end
  Rails.logger.debug "Done"
end
