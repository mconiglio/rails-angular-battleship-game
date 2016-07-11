class Position < ActiveRecord::Base
  belongs_to :game
  after_initialize :defaults

  # Sets the value of shooted to true.
  #
  # @return [void]
  def shoot!
    update_attribute(:shooted, true)
  end

  private

  # Sets the default values of water and shooted attributes.
  #
  # @return [void]
  def defaults
    self.water = true if water.nil?
    self.shooted = false if shooted.nil?
  end
end
