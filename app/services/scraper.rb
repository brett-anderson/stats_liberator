require 'service'
require 'open-uri'

class Scraper
  include Service

  # Gourmet Service Object.
  # Invoke using AdvanceRounds.call
  def initialize


  end

  def call
    Player.where(name: nil).destroy_all

    id = 1
    players_processed = 0

    while players_processed < 40
      player = player.where(id: id)

      unless player.count > 0
        player = find_player(id)
        Rails.logger.info "id: #{id}, player: #{player.name}"
        if player.name && player.save
          Rails.logger.info "#{player.name} saved."
        else
          Rails.logger.info "failed to save with id: #{id}."
        end
        sleep 15.seconds
        players_processed = players_processed + 1
      end
      id = id + 1
    end
  end

  private

  def find_player(id)
    doc = Nokogiri::HTML(open("http://sports.yahoo.com/nhl/players/#{id}/"))
    player = Player.create(html: doc.to_s)
    player.name = doc.at_css('.player-info h1') ? doc.at_css('.player-info h1').attributes['data-name'].value : nil
    player.yahoo_id = id
  end

end
