class StatsLiberator

  include Service

  def initialize

  end

  def call

   require 'open-uri'
   doc = Nokogiri::HTML(open("http://sports.yahoo.com/nhl/players/1/"))
   player = Player.create(html: doc.to_s)
   player.save  
  end
end
