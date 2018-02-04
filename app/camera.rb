class Camera
  include ScreenSizes

  attr_accessor :node, :target_scale,
                :target_position, :scale_rate,
                :trauma, :main_layer

  def initialize parent
    @node = SKNode.new
    @main_layer = SKNode.new
    @target_scale = origin_scale
    @scale_rate = 0.3
    @trauma = 0
    @positive_negative = [-1, 1]
    @node.addChild @main_layer
    @node.position = CGPointMake(origin_x, origin_y)
    @node.xScale = origin_scale
    @node.yScale = origin_scale

    parent.addChild @node
  end

  def origin_x
    return @origin_x if @origin_x

    @origin_x = device_screen_width.fdiv(2)

    if iPad?
      @origin_x -= 125.fdiv(2)
    elsif iPhoneX?
      @origin_x -= 4.fdiv(2)
    elsif iPhone6?
      @origin_x -= 7.fdiv(2)
    elsif iPhone6Plus?
      @origin_x -= 15.fdiv(2)
    elsif iPhone5?
      @origin_x -= 8.fdiv(2)
    end

    @origin_x
  end

  def origin_y
    return @origin_y if @origin_y

    @origin_y = device_screen_height.fdiv(2)

    @origin_y
  end

  def origin_scale
    return @origin_scale if @origin_scale

    if iPad?
      @origin_scale = 0.70
    elsif iPhoneX?
      @origin_scale = 0.98
    elsif iPhone6?
      @origin_scale = 0.96
    elsif iPhone6Plus?
      @origin_scale = 0.92
    elsif iPhone5?
      @origin_scale = 0.95
    end
  end

  def addChild child
    @main_layer.addChild child
  end

  def pan_up
    @target_y ||= @main_layer.position.y
    @target_y -= 200 * @node.yScale
  end

  def pan_down
    @target_y ||= @main_layer.position.y
    @target_y += 200 * @node.yScale
  end

  def pan_left
    @target_x ||= @main_layer.position.x
    @target_x += 200 * @node.xScale
  end

  def pan_right
    @target_x ||= @main_layer.position.x
    @target_x -= 200 * @node.xScale
  end

  def update_scale
    differences = target_scale.round(2) - @node.xScale.round(2)

    return if differences.zero?

    @node.xScale += differences * @scale_rate
    @node.yScale += differences * @scale_rate
  end

  def update_location
    return if !@target_x && !@target_y

    @main_layer.position = CGPointMake(@main_layer.position.x +
                                 (((@target_x || @main_layer.position.x) - @main_layer.position.x) * @scale_rate),
                                 @main_layer.position.y +
                                 (((@target_y || @main_layer.position.y) - @main_layer.position.y) * @scale_rate))

    @target_x = nil if @target_x && @main_layer.position.x.round(2) == @target_x.round(2)
    @target_y = nil if @target_y && @main_layer.position.y.round(2) == @target_y.round(2)
  end

  def update_trauma
    return if @trauma.round(4) == 0

    calculated_trauma = (3.14).fdiv(15) * @trauma * @trauma

    @trauma = @trauma * 0.9

    if @node.zRotation >= 0
      @node.zRotation = -calculated_trauma
    else
      @node.zRotation = calculated_trauma
    end

    calculated_offset = 100 * @trauma * @trauma

    offset_x = calculated_offset * rand * @positive_negative.sample
    offset_y = calculated_offset * rand * @positive_negative.sample

    @node.position = CGPointMake(origin_x + offset_x,
                                 origin_y + offset_y)
  end

  def update
    update_scale
    update_location
    update_trauma
  end
end
