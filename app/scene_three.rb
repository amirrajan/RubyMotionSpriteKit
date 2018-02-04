class SceneThree < SKScene
  include ScreenSizes

  attr_accessor :root

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    # Add instructions for this scene.
    add_label <<-HERE
    This is scene three.

    Tap with one finger to add a spinning square where you tapped.

    Tap with two fingers to go to the next scene. To perform a two finger touch in the simulator, hold down the option key and then tap.

    You know the drill. Read the code in scene_three.rb to see how the sausage is made.
    HERE

    @squares = []
  end

  def touchesBegan touches, withEvent: _
    if touches.allObjects.count == 1
      touches.allObjects.each do |t|
        @squares << add_sprite(t.locationInNode(self).x,
                               t.locationInNode(self).y,
                               'square.png')
      end
    else
      root.present_scene_four
    end
  end

  def add_sprite x, y, path
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    addChild sprite
    sprite
  end

  # The render loop, each square that has been added is enumerated.
  def update currentTime
    @squares.each { |s| s.zRotation += 0.1 }
  end

  def wrap wrap_length, text
    StringWrapper.wrap wrap_length, text
  end

  def add_label text
    font_size = 12
    wrapped_text = wrap 38, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(3,
                                   device_screen_height - 50 - ((i + 1) * font_size))
      addChild label
    end
  end
end
