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

    Player.where(height: nil).each do |player|
      player.generate_columns_from_html
      player.save
    end

  end

  def call

    id = @id
    id = id + 1
    players_processed = 0

    @missing_ids.each do |id|
      player = find_player(id)

      if player
        Rails.logger.info "id: #{id}, player: #{player.name}"
        if player.name && player.save
          Rails.logger.info "#{player.name} saved."
        else
          Rails.logger.info "failed to save with id: #{id}."
        end
        sleep 15.seconds
        players_processed = players_processed + 1
      end
    end



    while players_processed < 30 && id < 8000
      current_player = Player.where(id: id)

      player = find_player(id) if current_player.count == 0

      if player
        Rails.logger.info "id: #{id}, player: #{player.name}"
        if player && player.name && player.save
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
    begin
      doc = Nokogiri::HTML(open("http://sports.yahoo.com/nhl/players/#{id}/"))
    rescue OpenURI::HTTPError
      Rails.logger.info "PLAYER NOT FOUND AT #{id}"
      return nil
    end
    player = Player.create(html: doc.to_s, yahoo_id: id)
  end

end
