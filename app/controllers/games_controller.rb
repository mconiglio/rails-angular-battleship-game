class GamesController < ApiController
  GAMES_PER_PAGE = 10
  before_filter :authenticate_user

  # Gets a JSON including the data of all the games of the logged user.
  #
  # @return [JSON] the JSON with the games data.
  def index
    @games = current_user.games_ended.paginate(page: current_page, per_page: GAMES_PER_PAGE)
    games_count = current_user.games_ended.count

    render json: { games_count: games_count,
                   current_page: current_page,
                   total_pages: total_pages(games_count),
                   games: @games
    }, status: 200
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

  private

  # Sets the default page if not established.
  #
  # @return [Fixnum]
  def current_page
    (params[:page].blank? ? 1 : params[:page]).to_i
  end

  # Calculates the number of pages necessary for the quantity of records.
  #
  # @param games_count [Fixnum] the quantity of records.
  # @return [Fixnum] the number of pages.
  def total_pages(games_count)
    (games_count % GAMES_PER_PAGE == 0 ? games_count / GAMES_PER_PAGE : games_count / GAMES_PER_PAGE + 1).to_i
  end
end
