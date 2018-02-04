class SceneSixGame
  attr_accessor :ship_x, :ship_y, :target_x, :target_y

  def initialize
    @ship_x = 0
    @ship_y = 0
    @target_x = 0
    @target_y = 0
  end

  def update
    delta_x = (@target_x - @ship_x)
    @ship_x += delta_x * 0.2
  end
end
