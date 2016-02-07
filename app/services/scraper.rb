require 'service'
require 'open-uri'

class Scraper
  include Service

  # Gourmet Service Object.
  # Invoke using AdvanceRounds.call
  def initialize
    Player.where(name: nil).destroy_all
    @id = Player.last ? Player.last.id : 1

    @yahoo_ids = Player.all.order(:yahoo_id).pluck(:yahoo_id).uniq
    @entire_ids =*(1..@yahoo_ids.last)

    @missing_ids = @entire_ids - @yahoo_ids

  end

  def call

    id = @id
    id = id + 1
    players_processed = 0

    @missing_ids.each do |id|
      player = find_player(id)
      players_processed = players_processed + 1 if player
      sleep 15.seconds
    end



    while players_processed < 15 && id < 7500
      current_player = Player.where(id: id)

      player = find_player(id) if current_player.count == 0
      players_processed = players_processed + 1 if player
      sleep 15.seconds
      id = id + 1
    end
  end

  private

  def find_player(id)
    begin
    player = Player.create(yahoo_id: id)
    player.generate_columns_from_html
    rescue OpenURI::HTTPError
      Rails.logger.info "PLAYER NOT FOUND AT #{id}"
      return nil
    end
    player.save
  end

end
