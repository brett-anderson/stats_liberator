class PlayersController < ApplicationController
  def index
   @players = Player.all.limit(20)
  end
  def show
   @player = Player.find(params[:id])
   @names = Player.all.pluck(:name).uniq
  end
end
