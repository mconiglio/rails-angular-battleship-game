class PositionSerializer < ActiveModel::Serializer
  attributes :id, :x, :y, :water, :shooted

  belongs_to :game

  def attributes(*args)
    object.shooted? ? super : super.except(:water)
  end
end
