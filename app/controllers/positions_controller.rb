class PositionsController < ApiController
  before_filter :authenticate_user

  # Sets the status of shooted to true.
  #
  # @return [JSON] with the attributes of the updated position
  #   or an error message if the position belongs to another user
  #   or game.
  def update
    @game = current_or_guest_user.games.find_by(id: params[:game_id])
    @position = @game.positions.find_by(id: params[:id]) if @game

    if @position && !@position.shooted? && !@game.finished?
      @game.shoot_position!(@position)
      render json: @position, status: 200
    else
      render json: { 'error': "You can't shoot this position." }, status: 401
    end
  end
end
