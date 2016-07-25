class LeaderboardsController < ApiController
  USERS_PER_PAGE = 10

  # Gets a JSON including the users with more accumulated points
  #  and the count of total users having games.
  #
  # @return [JSON] the JSON with the users data and quantity of users with games.
  def index
    @users = User.top_players.paginate(page: current_page, per_page: USERS_PER_PAGE)
    users_with_games = User.with_games.count

    render json: {
        users_count: users_with_games,
        current_page: current_page,
        total_pages: total_pages(users_with_games),
        users: @users
    }, status: 200
  end

  private

  # Set the default page number if not established.
  #
  # @return [Fixnum] the page number.
  def current_page
    (params[:page].blank? ? 1 : params[:page]).to_i
  end

  # Calculates the number of pages necessary for the quantity of records.
  #
  # @param users_count [Fixnum] the quantity of records.
  # @return [Fixnum] the number of pages.
  def total_pages(users_count)
    (users_count % USERS_PER_PAGE == 0 ? users_count / USERS_PER_PAGE : users_count / USERS_PER_PAGE + 1).to_i
  end
end
