class PlayersController < ApplicationController
  def index
   @players = Player.all.limit(20)
  end
  def show
   @player = Player.find(params[:id])
  end
end
