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

      player.name = doc.at_css('.player-info h1').attributes ? doc.at_css('.player-info h1').attributes['data-name'].value
      player.yahoo_id = id
      if player.save
        Rails.logger.info "#{Player.name} saved."
      end
      iterations = iterations + 1
      id = id + 1
      sleep 10.seconds
    end
  end
end
