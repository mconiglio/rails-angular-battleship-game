class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :games
  scope :top_players, -> { joins(:games)
                               .select('users.id, users.email, sum(games.points) as total_points')
                               .group('users.id')
                               .order('total_points desc') }
  scope :with_games, -> { where('games_count > 0') }


  # Gets an array with all the games ended that belongs to the user
  #   ordered by the ended_at attribute.
  #
  # @return [Array] the array with the games ended.
  def games_ended
    self.games.ended.by_ended_at
  end
end
