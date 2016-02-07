class PlayersController < ApplicationController
  def index
  #  @players = Player.all.limit(20)
   @players = Player.order(:yahoo_id).paginate(:page => params[:page], :per_page => 50)

  end
  def show
   @player = Player.find(params[:id])
  end
end
