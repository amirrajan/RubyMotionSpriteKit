class SceneFive < SKScene
  include ScreenSizes

  attr_accessor :root

  # A little helper method that can be used to get the camera in the repl.
  def get_camera
    return @camera
  end

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    #initalize a camera, all sprites go into the camera
    @camera = Camera.new self

    # Add instructions for this scene.
    # The add label method in this scene is a bit fancier. Take a look at it.
    add_label <<-HERE, 0, 0, 0.5, 0.5, @camera.main_layer
    This is the first screen that will actually look pretty okay on all devices.

    Try running:
    `rake device_name='iPhone X'`
    `rake device_name='iPhone 8'`
    `rake device_name='iPhone 8 Plus'`
    `rake device_name='iPhone 5s'`
    `rake device_name='iPad Pro (12.9-inch)'`

    Tap anywhere to add squares. Use the buttons at the bottom to pan, zoom, and shake the camera.

    You'll want to read the code in scene_five.rb and camera.rb.

    Tap with multiple fingers to go to the next scene.
    HERE

    $scene = self

    # Spoiler alert. Buttons are just sprites. Everything is a sprite. Everything.
    @button_left         = add_button( 40,  80, 'button-left')
    @button_right        = add_button(110,  80, 'button-right')
    @button_up           = add_button( 75, 120, 'button-up')
    @button_down         = add_button( 75,  40, 'button-down')
    @button_out          = add_button(device_screen_width.fdiv(2),  40, 'button-out')
    @button_in           = add_button(device_screen_width.fdiv(2),  90, 'button-in')
    @button_camera_shake = add_button(device_screen_width - 40, 60, 'button-shake')

    # these are all the sprites
    @squares = []
  end

  def touchesBegan touches, withEvent: _
    # This is how you get the node at a specific location that was touched.
    node = nodeAtPoint(touches.allObjects.first.locationInNode(self))

    # once you have the node location, you can look at
    # its name to determine what you want to do with the node.
    case node.name
    when 'button-right'
      node.xScale = node.yScale = 2
      @camera.pan_left
    when 'button-out'
      node.xScale = node.yScale = 2
      @camera.target_scale = @camera.target_scale * 0.9
    when 'button-in'
      node.xScale = node.yScale = 2
      @camera.target_scale = @camera.target_scale * 1.1
    when 'button-left'
      node.xScale = node.yScale = 2
      @camera.pan_right
    when 'button-up'
      node.xScale = node.yScale = 2
      @camera.pan_up
    when 'button-down'
      node.xScale = node.yScale = 2
      @camera.pan_down
    when 'button-shake'
      node.xScale = node.yScale = 2
      @camera.trauma += 0.6
    else
      # if the area that was tapped is not a button,
      # get the touch location and add a sprite.
      first_touch = touches.allObjects.first

      # the sprite should be added to the camera's main layer the `locationInNode`
      # function is important to include when determining the x and y position.
      @squares << add_sprite(first_touch.locationInNode(@camera.main_layer).x,
                             first_touch.locationInNode(@camera.main_layer).y,
                             'square.png',
                             "square-#{@squares.length + 1}",
                             @camera)
    end

    return unless touches.allObjects.count > 1

    root.present_scene_six
  end

  def update _
    # Each tick, spin the square.
    @squares.each { |s| s.zRotation += 0.1 }

    # update button animations
    update_buttons

    # update the camera (specifically zoom, scale, trauma etc).
    @camera.update
  end

  def update_buttons
    # For each button, set it's scale down to it's original
    # value. Protip, never use subtraction or addition for
    # incremental changes to a node. Always use a percent.
    # Take a look at the bring_node_to_target_scale method to see
    # what I mean.
    bring_node_to_target_scale @button_right
    bring_node_to_target_scale @button_out
    bring_node_to_target_scale @button_in
    bring_node_to_target_scale @button_left
    bring_node_to_target_scale @button_up
    bring_node_to_target_scale @button_down
    bring_node_to_target_scale @button_camera_shake, 1.5
  end

  def bring_node_to_target_scale node, target_scale = 1
    scale_difference = target_scale - node.xScale
    node.xScale += scale_difference * 0.3
    node.yScale += scale_difference * 0.3
  end

  def wrap wrap_length, text
    StringWrapper.wrap wrap_length, text
  end

  def add_label text, x, y, anchor_x, anchor_y, parent
    labels = []
    font_size = 12
    wrapped_text = wrap 50, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(x, y - ((i + 1) * font_size))
      labels << label
      parent.addChild label
    end

    max_width = labels.map { |l| l.frame.size.width }.max
    total_height = labels.map { |l| l.frame.size.height }.inject(:+)

    labels.each do |l|
      delta_x = -max_width * anchor_x
      delta_y = total_height * (1 - anchor_y)
      l.position = CGPointMake(l.position.x + delta_x, l.position.y + delta_y)
    end
  end

  def add_button x, y, name, parent = self, scale = 1
    button = add_sprite(x, y, 'button.png', name, parent)
    button.zPosition = 1000
    button.xScale = scale
    button.yScale = scale
    button
  end

  def add_sprite x, y, path, name, parent
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    sprite.name = name
    sprite.size = CGSizeMake(50, 50)
    parent.addChild sprite
    sprite
  end
end
