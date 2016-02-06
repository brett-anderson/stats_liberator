require 'service'
require 'open-uri'

class Scraper
  include Service

  # Gourmet Service Object.
  # Invoke using AdvanceRounds.call
  def initialize


  end

  # Advance each round
  def call
    doc = Nokogiri::HTML(open("http://sports.yahoo.com/nhl/players/1/"))
    player = Player.create(html: doc.to_s)
    player.save
  end
end
