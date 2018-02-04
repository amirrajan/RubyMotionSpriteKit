class SceneSixGame
  ENEMY_SIZE = 50
  attr_accessor :ship_x,
                :ship_y,
                :target_x,
                :target_y,
                :bullet_location_y,
                :bullet_location_x,
                :enemies

  def initialize
    @ship_x = 0
    @ship_y = 0
    @target_x = 0
    @target_y = 0
    @enemies = 10.times.map do |i|
      {
        id: i.to_s,
        x: (5 * -ENEMY_SIZE) + (i * ENEMY_SIZE),
        y: 600
      }
    end
  end

  def update
    delta_x = (@target_x - @ship_x)
    @ship_x += delta_x * 0.2

    @bullet_location_y += 10 if @bullet_location_y

    if @bullet_location_y && @bullet_location_y > 630
      @bullet_location_y = nil
    end
  end

  def enemy_was_hit id
    @enemies.delete(@enemies.find { |e| e[:id] == id })
    @bullet_location_y = nil
  end

  def fire_bullet
    return if @bullet_location_y

    @bullet_location_x = @ship_x
    @bullet_location_y = @ship_y
  end
end
