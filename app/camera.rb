class Camera
  include ScreenSizes

  attr_accessor :node, :target_scale, :target_position, :scale_rate

  def initialize parent
    @node = SKNode.new
    @target_scale = 1
    @scale_rate = 0.3
    @original_width  = device_screen_width
    @original_height = device_screen_height
    parent.addChild @node
  end

  def addChild child
    @node.addChild child
  end

  def pan_left
    @target_x ||= @node.position.x
    @target_x += 50
  end

  def pan_right
    @target_x ||= @node.position.x
    @target_x -= 50
  end

  def pan_up amount
    @target_y = amount
  end

  def update
    differences = target_scale.round(2) - @node.xScale.round(2)
    if differences > 0
      @node.xScale += differences * @scale_rate
      @node.yScale += differences * @scale_rate

      target_x_difference = (@original_width - (@original_width * @node.xScale)).fdiv(2) - @node.position.x
      target_y_difference = (@original_height - (@original_height * @node.yScale)).fdiv(2) - @node.position.y

      @node.position = CGPointMake(@node.position.x + target_x_difference,
                                   @node.position.y + target_y_difference)
    end

    if @target_x
      @node.position = CGPointMake(@node.position.x +
                                   (((@target_x || @node.position.x) - @node.position.x) * @scale_rate),
                                   @node.position.y +
                                   (((@target_y || @node.position.y) - @node.position.y) * @scale_rate))
      @target_x = nil if @node.position.x.round(2) == @target_x.round(2)
    end
  end
end
