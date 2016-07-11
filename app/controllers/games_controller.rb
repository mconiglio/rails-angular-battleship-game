class GamesController < ApiController
  before_filter :authenticate_user

  # Gets a JSON including the data of all the games.
  #
  # @return [JSON] the JSON with the games data.
  def index
    @games = Game.all
    render json: @games, status: 200
  end

  # Gets a JSON including all the data of the game
  #   including its positions.
  #
  # @return [JSON] the JSON with the attributes of the game.
  def show
    @game = Game.find(params[:id])
    render json: @game, status: 200
  end

  # Creates a new game and returns a JSON with its attributes.
  #
  # @return [JSON] the JSON with the attributes of the game.
  def create
    @game = current_user.games.create
    render json: @game, status: 201
  end
end
