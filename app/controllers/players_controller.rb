class PlayersController < ApplicationController
  def index
  #  @players = Player.all.limit(20)
   @players = Player.order(:yahoo_id).paginate(:page => search_params[:page], :per_page => 50) unless index_params[:search]
   @players = Player.order(:yahoo_id).where(
    "name ilike :search or team ilike :search", search: "%#{index_params[:search]}%"
   ).paginate(:page => search_params[:page], :per_page => 50) if index_params[:search]


  end
  def show
   @player = Player.find(show_params[:id])
  end

  private

  def index_params
    params.permit(:search, :page)
  end

  def show_params
    params.permit(:id)
  end
end
