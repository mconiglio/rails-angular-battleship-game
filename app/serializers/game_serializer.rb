class GameSerializer < ActiveModel::Serializer
  attributes :id, :shots_on_target, :shots_missed, :time_played, :points, :remaining_shots,
             :ended_at, :created_at

  belongs_to :user
  has_many :positions
end