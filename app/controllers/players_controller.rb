class PlayersController < ApplicationController
  def index
  #  @players = Player.all.limit(20)
   @names = Player.all.pluck(:name).uniq
  end
  def show
   @player = Player.find(params[:id])
  end
end
