class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :games

  # Gets an array with all the games ended that belongs to the user
  #   ordered by the ended_at attribute.
  #
  # @return [Array] the array with the games ended.
  def games_ended
    self.games.ended.by_ended_at
  end
end
