require 'service'
require 'open-uri'

class Scraper
  include Service

  # Gourmet Service Object.
  # Invoke using AdvanceRounds.call
  def initialize
    last_player = Player.order(:yahoo_id).last
    @id = last_player ? last_player.yahoo_id : 1
  end

  def call

    id = @id

    while id < 7500
      current_player = Player.where(id: id)
      player = find_player(id) if current_player.count == 0
      Rails.logger.info "PLAYER ADDED: #{player.name}" if player
      Rails.logger.info "no player added :(, id: #{id}" unless player
      sleep 5.seconds
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
    player if player.save
  end

end
