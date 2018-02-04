class SceneSixGame
  attr_accessor :ship_x,
                :ship_y,
                :target_x,
                :target_y,
                :bullet_location_y,
                :bullet_location_x,
                :enemy_x,
                :enemy_y

  def initialize
    @ship_x = 0
    @ship_y = 0
    @target_x = 0
    @target_y = 0
    @enemy_x = 0
    @enemy_y = 600
  end

  def update
    delta_x = (@target_x - @ship_x)
    @ship_x += delta_x * 0.2

    @bullet_location_y += 1 if @bullet_location_y

    if @bullet_location_y && @bullet_location_y > 630
      @bullet_location_y = nil
    end
  end

  def enemy_was_hit
    @enemy_x = nil
    @enemy_y = nil
    @bullet_location_y = nil
  end

  def fire_bullet
    return if @bullet_location_y

    @bullet_location_x = @ship_x
    @bullet_location_y = @ship_y
  end
end
