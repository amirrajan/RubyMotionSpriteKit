class Camera
  include ScreenSizes

  attr_accessor :node, :target_scale,
                :target_position, :scale_rate,
                :trauma

  def initialize parent
    @node = SKNode.new
    @target_scale = 1
    @scale_rate = 0.3
    @original_width  = device_screen_width
    @original_height = device_screen_height
    @trauma = 1
    parent.addChild @node
  end

  def addChild child
    @node.addChild child
  end

  def pan_up
    @target_y ||= @node.position.x
    @target_y += 200 * @node.xScale
  end

  def pan_down
    @target_y ||= @node.position.x
    @target_y -= 200 * @node.xScale
  end

  def pan_left
    @target_x ||= @node.position.x
    @target_x += 200 * @node.xScale
  end

  def pan_right
    @target_x ||= @node.position.x
    @target_x -= 200 * @node.xScale
  end

  def update_scale
    differences = target_scale.round(2) - @node.xScale.round(2)

    return unless differences != 0

    current_width = @node.xScale * device_screen_width
    current_height = @node.xScale * device_screen_height

    @node.xScale += differences * @scale_rate
    @node.yScale += differences * @scale_rate

    new_width = @node.xScale * device_screen_width
    new_height = @node.yScale * device_screen_height

    width_difference = (new_width - current_width).fdiv(2)
    height_difference = (new_height - current_height).fdiv(2)

    new_center_x = (@target_x || @node.position.x) - width_difference
    new_center_y = (@target_y || @node.position.y) - height_difference

    @target_x = new_center_x
    @target_y = new_center_y
  end

  def update_location
    return if !@target_x && !@target_y

    @node.position = CGPointMake(@node.position.x +
                                 (((@target_x || @node.position.x) - @node.position.x) * @scale_rate),
                                 @node.position.y +
                                 (((@target_y || @node.position.y) - @node.position.y) * @scale_rate))
    @target_x = nil if @target_x && @node.position.x.round(2) == @target_x.round(2)
    @target_y = nil if @target_y && @node.position.y.round(2) == @target_y.round(2)
  end

  def update_trauma
    return if @trauma == 0

    calculated_trauma = (3.14)

    @node.zRotation += 1
  end

  def update
    update_scale
    update_location
    update_trauma
  end
end
