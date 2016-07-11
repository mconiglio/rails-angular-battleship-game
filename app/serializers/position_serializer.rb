class PositionSerializer < ActiveModel::Serializer
  attributes :id, :x, :y, :water, :shooted

  belongs_to :game
end
