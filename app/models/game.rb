class Game < ActiveRecord::Base
  GAME_BOARD_LENGTH = 10
  GAME_SHIPS = ([5] * 2 + [3] * 3 + [1] * 5)

  belongs_to :user
  has_many :positions
  after_create :create_positions
  scope :ended, -> { where('ended_at IS NOT NULL') }
  scope :by_ended_at, -> { order('ended_at DESC') }

  # Decrements the remaining shots if it missed the targets.
  #   If the shot produces the game completion it sets the
  #   ended_at time and the points
  #
  # @param missed_target [Boolean] indicates if the shot was missed.
  # @return [void]
  def decrement_remaining_shots(missed_target)
    self.remaining_shots -= 1 if missed_target
    if remaining_shots == 0 || all_ships_sunk
      self.ended_at = Time.zone.now
      self.points = ((500 * shots_on_target) - (50 * shots_missed)) / time_played
    end
    save
  end

  # Gets the quantity of positions that were shooted and had a ship.
  #
  # @return [Fixnum] the quantity of positions.
  def shots_on_target
    self.positions.where(water: false, shooted: true).count
  end

  # Gets the quantity of positions that were shooted and hadn't a ship.
  #
  # @return [Fixnum] the quantity of positions.
  def shots_missed
    self.positions.where(water: true, shooted: true).count
  end

  # Gets the the duration of the game if it has ended or the time
  #   between the current time and the start of the game otherwise.
  #
  # @return [Fixnum] the duration in seconds.
  def time_played
    self.ended_at ? (ended_at - created_at).to_i : (Time.zone.now - created_at).to_i
  end

  # Determines if the game has ended.
  #
  # @return [Boolean] true if game has ended or false otherwise.
  def finished?
    !!self.ended_at
  end

  def shoot_position!(position)
    position.shoot!
    decrement_remaining_shots(position.water?)
  end

  # Creates all the positions of the board and sets the ships.
  #
  # @return [void]
  def create_positions
    (1..GAME_BOARD_LENGTH).each do |y|
      (1..GAME_BOARD_LENGTH).each do |x|
        self.positions.new(x: x, y: y)
      end
    end
    set_ships
    save
  end

  # Sets all the ships randomly on the board.
  #
  # @return [void]
  def set_ships
    GAME_SHIPS.each do |ship|
      loop do
        horizontal = [true, false].sample
        x = horizontal ? rand(1..GAME_BOARD_LENGTH - ship) : rand(1..GAME_BOARD_LENGTH)
        y = !horizontal ? rand(1..GAME_BOARD_LENGTH - ship) : rand(1..GAME_BOARD_LENGTH)

        break if place_ship(x, y, ship, horizontal)
      end
    end
  end

  # Places a ship on the board.
  #
  # @param x [Fixnum] the x coordinate where the ships start.
  # @param y [Fixnum] the y coordinate where the ships start.
  # @param ship [Fixnum] the length of the ship.
  # @param horizontal [Boolean] indicates if the ship is horizontal.
  # @return [void]
  def place_ship(x, y, ship, horizontal)
    if horizontal && all_water_in_row?(y, x, x + ship)
      set_horizontal_ship(y, x, x + ship)
    elsif !horizontal && all_water_in_column?(x, y, y + ship)
      set_vertical_ship(x, y, y + ship)
    end
  end

  # Check if a row is empty between x_min and x_max.
  #
  # @param y [Fixnum] the number of row.
  # @param x_min [Fixnum] the left limit of the evaluated positions.
  # @param x_max [Fixnum] the right limit of the evaluated positions.
  # @return [Boolean] true if the row is empty, false otherwise
  def all_water_in_row?(y, x_min, x_max)
    !self.positions.any? { |pos| pos.y == y && pos.x >= x_min && pos.x < x_max && !pos.water? }
  end

  # Check if a column is empty between y_min and y_max.
  #
  # @param x [Fixnum] the number of row.
  # @param y_min [Fixnum] the top limit of the evaluated positions.
  # @param y_max [Fixnum] the bottom limit of the evaluated positions.
  # @return [Boolean] true if the column is empty, false otherwise
  def all_water_in_column?(x, y_min, y_max)
    !self.positions.any? { |pos| pos.x == x && pos.y >= y_min && pos.y < y_max && !pos.water? }
  end

  # Sets a ship in a row between x_min and x_max.
  #
  # @param y [Fixnum] the number of row.
  # @param x_min [Fixnum] the left limit of the evaluated positions.
  # @param x_max [Fixnum] the right limit of the evaluated positions.
  # @return [void]
  def set_horizontal_ship(y, x_min, x_max)
    (x_min...x_max).each { |x| self.positions.find { |p| p.x == x && p.y == y }.water = false }
  end

  # Sets a ship in a column between y_min and y_max.
  #
  # @param x [Fixnum] the number of row.
  # @param y_min [Fixnum] the top limit of the evaluated positions.
  # @param y_max [Fixnum] the bottom limit of the evaluated positions.
  # @return [void]
  def set_vertical_ship(x, y_min, y_max)
    (y_min...y_max).each { |y| self.positions.find { |p| p.x == x && p.y == y }.water = false }
  end

  # Check if all the ships are sunk.
  #
  # @return [Boolean] indicates if all the ships are sunk or not.
  def all_ships_sunk
    GAME_SHIPS.sum == shots_on_target
  end
end
