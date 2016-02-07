require 'service'
class MissingIds
  include Service

  def initialize

    @yahoo_ids = Player.all.order(:yahoo_id).pluck(:yahoo_id).uniq
    @entire_ids =*(1..@yahoo_ids.last)

    @missing_ids = @entire_ids - @yahoo_ids

  end

  def call
    @missing_ids.each do |missing_id|
      player = find_player(missing_id)
      players_processed = players_processed + 1 if player
      Rails.logger.info "PLAYER ADDED: #{player.name}" if player
      sleep 5.seconds
    end
  end

end
