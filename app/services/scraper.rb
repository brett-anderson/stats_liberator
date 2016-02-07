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
    id = Player.last ? Player.last.id : 1

    iterations = 0

    while iterations < 25
      doc = Nokogiri::HTML(open("http://sports.yahoo.com/nhl/players/#{id}/"))
      player = Player.create(html: doc.to_s)

      player.name = doc.at_css('.player-info h1') ? doc.at_css('.player-info h1').attributes['data-name'].value : nil
      player.yahoo_id = id
      Rails.logger.info "id: #{id}, player: #{player.name}"
      if player.name && player.save
        Rails.logger.info "#{player.name} saved."
      else
        Rails.logger.info "failed to save."
      end
      iterations = iterations + 1
      id = id + 1
      sleep 15.seconds
    end
  end
end
