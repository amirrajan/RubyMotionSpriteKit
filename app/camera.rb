# Here is a general camera concept. This is not meant to be a be all
# end all camera. But should be used as a spring board for your own
# camera needs.
class Camera
  include ScreenSizes

  attr_accessor :node, :target_scale,
                :target_position, :scale_rate,
                :trauma, :main_layer, :target_y,
                :target_x

  def initialize parent
    # this node represents the camera and is centered in the center of
    # the specific device (and specific scale)
    @node = SKNode.new

    # all sprites in your game should be added to the main layer.
    @main_layer = SKNode.new

    # setting the target_scale property will ease a camera to a
    # specific scale over time.
    @target_scale = scale_for_device

    # this property controls how quickly the camera pans and zooms
    @scale_rate = 0.1

    # this property controls how much shake is applied to the camera.
    @trauma = 0

    # lookup array that is used for camera shakes.
    @positive_negative = [-1, 1]

    @node.addChild @main_layer
    @node.position = CGPointMake(origin_x, origin_y)

    # the origin/beginning scale for a given device is calculated here.
    @node.xScale = scale_for_device

    # the origin/beginning scale for a given device is calculated here.
    @node.yScale = scale_for_device

    # add the camera to the parent
    parent.addChild @node
  end

  def pin_to_bottom_middle
    @origin_y = 40
    @node.position = CGPointMake(origin_x, origin_y)
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

  def scale_for_device
    return @scale_for_device if @scale_for_device

    if iPad?
      @scale_for_device = 0.70
    elsif iPhoneX?
      @scale_for_device = 0.98
    elsif iPhone6?
      @scale_for_device = 0.96
    elsif iPhone6Plus?
      @scale_for_device = 0.92
    elsif iPhone5?
      @scale_for_device = 0.80
    end
  end

  def addChild child
    @main_layer.addChild child
  end

  # this is a sample method showning how you can control the camera,
  # setting the target_y, target_x property of the camera will accomplish the
  # same thing
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

  # this method needs to be called in the main update loop so that
  # changes to scale, location, and trauma are applied.
  def update
    update_scale
    update_location
    update_trauma
  end

  # update to the target scale based on the scale rate
  def update_scale
    differences = target_scale.round(2) - @node.xScale.round(2)

    return if differences.zero?

    @node.xScale += differences * @scale_rate
    @node.yScale += differences * @scale_rate
  end

  # update to the target location based on the scale rate
  def update_location
    return if !@target_x && !@target_y

    # maaaaaaaattttthhhh
    @main_layer.position = CGPointMake(@main_layer.position.x +
                                 (((@target_x || @main_layer.position.x) - @main_layer.position.x) * @scale_rate),
                                 @main_layer.position.y +
                                 (((@target_y || @main_layer.position.y) - @main_layer.position.y) * @scale_rate))

    @target_x = nil if @target_x && @main_layer.position.x.round(2) == @target_x.round(2)
    @target_y = nil if @target_y && @main_layer.position.y.round(2) == @target_y.round(2)
  end

  # this is how camera shake is applied, play around with the values
  # to find something that works well for you.
  def update_trauma
    return if @trauma.round(4) == 0

    # rotational camera shake
    calculated_trauma = (3.14).fdiv(15) * @trauma * @trauma

    @trauma = @trauma * 0.9

    if @node.zRotation >= 0
      @node.zRotation = -calculated_trauma
    else
      @node.zRotation = calculated_trauma
    end

    # positional camera shake
    calculated_offset = 100 * @trauma * @trauma

    offset_x = calculated_offset * rand * @positive_negative.sample
    offset_y = calculated_offset * rand * @positive_negative.sample

    @node.position = CGPointMake(origin_x + offset_x,
                                 origin_y + offset_y)
  end

end
