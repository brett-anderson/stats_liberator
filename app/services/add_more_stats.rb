require 'service'
class AddMoreStats
  include Service


  def initialize

  end

  def call

    Player.find_each(batch_size: 30) do | player |
      player.get_stats unless player.image
    end

  end




end
