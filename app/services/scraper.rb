require 'service'
require 'open-uri'

class Scraper
  include Service

  # Gourmet Service Object.
  # Invoke using AdvanceRounds.call
  def initialize



  end

  def call
    id = Player.where(position: nil).order(:yahoo_id).first.yahoo_id
    while id < 7500
      current_player = Player.where(id: id)
      player = find_player(id) if current_player.count == 0
      Rails.logger.info "PLAYER ADDED: #{player.name}" if player
      Rails.logger.info "no player added :(, id: #{id}" if ! player && current_player.count == 0
      Rails.logger.info "Player found at #{id}, #{current_player.first.name}" if current_player.count > 0
      sleep 2.seconds if player
      id = id + 1
    end
  end

  private

  def find_player(id)
    begin
    player = Player.create(yahoo_id: id)
    player.get_stats
    rescue OpenURI::HTTPError
      Rails.logger.info "HTTPError, yahoo_id: #{id}"
    end
    player if player.save
  end

end
