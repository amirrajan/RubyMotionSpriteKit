class SceneFive < SKScene
  include ScreenSizes

  attr_accessor :root

  def get_camera
    return @camera
  end

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    # Add instructions for this scene.
    add_label <<-HERE
    HERE

    $scene = self

    # Spoiler alert. Buttons are just sprites. Everything is a sprite. Everything.
    @button_left = add_sprite(50, 70, 'button.png', 'button-left', self)
    @button_left.zPosition = 1000
    @button_right = add_sprite(100, 70, 'button.png', 'button-right', self)
    @button_right.zPosition = 1000

    @button_up = add_sprite(75, 110, 'button.png', 'button-up', self)
    @button_up.zPosition = 1000
    @button_down = add_sprite(75, 30, 'button.png', 'button-down', self)
    @button_down.zPosition = 1000

    @button_out  = add_sprite(190, 30, 'button.png', 'button-out', self)
    @button_out.zPosition = 1000
    @button_in   = add_sprite(190, 80, 'button.png', 'button-in', self)
    @button_in.zPosition = 1000
    @camera = Camera.new self
    @camera.scale_rate = 0.1

    @squares = []
  end

  def touchesBegan touches, withEvent: _
    # This is how you get the node at a specific location that was touched.
    node = nodeAtPoint(touches.allObjects.first.locationInNode(self))

    # once you have the node location, you can look at its name to determine what you want to do with the node.
    case node.name
    when 'button-right'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_left
    when 'button-out'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale = @camera.target_scale * 0.9
    when 'button-in'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale = @camera.target_scale * 1.1
    when 'button-left'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_right
    when 'button-up'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_up
    when 'button-down'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_down
    else
      first_touch = touches.allObjects.first

      @squares << add_sprite(first_touch.locationInNode(@camera.node).x,
                             first_touch.locationInNode(@camera.node).y,
                             'square.png',
                             "square-#{@squares.length + 1}",
                             @camera)
    end

    return unless touches.allObjects.count > 1

    root.present_scene_five
  end

  def update _
    @squares.each { |s| s.zRotation += 0.1 }

    bring_node_to_target_scale @button_right
    bring_node_to_target_scale @button_out
    bring_node_to_target_scale @button_in
    bring_node_to_target_scale @button_left
    bring_node_to_target_scale @button_up
    bring_node_to_target_scale @button_down

    @camera.update
  end

  def bring_node_to_target_scale node, target_scale = 1
    scale_difference = target_scale - node.xScale
    node.xScale += scale_difference * 0.3
    node.yScale += scale_difference * 0.3
  end

  def wrap wrap_length, text
    StringWrapper.wrap wrap_length, text
  end

  def add_label text
    font_size = 12
    wrapped_text = wrap 50, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(10,
                                   device_screen_height - ((i + 1) * font_size))
      addChild label
    end
  end

  def add_sprite x, y, path, name, parent
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    sprite.name = name
    sprite.size = CGSizeMake(50, 50)
    anchorPoint = CGPointMake 0.5, 0.5
    parent.addChild sprite
    sprite
  end
end
