class SceneTwo < SKScene
  include ScreenSizes

  attr_accessor :root

  # This method is invoked when a scene is presented.
  def didMoveToView _
    # Set the aspect ratio.
    self.scaleMode = SKSceneScaleModeAspectFit

    # Set the background color to white.
    self.backgroundColor = UIColor.whiteColor

    # Add instructions for this scene.
    add_label <<-HERE
    This is scene two. This scene shows a spinning sprite.

    The sprite code is located in the add_sprite method in scene_two.rb file. Take a look at it. Be sure to read all the comments in the file.

    Once you're done reading the code. Tap anywhere to go to the next scene.
    HERE

    # Add sprite (which will be updated in the render loop).
    # Assets are located inside of the resources folder.
    @square = add_sprite device_screen_width.fdiv(2),
                         device_screen_height.fdiv(2),
                         'square.png'
  end

  # This delegate is invoked when the scene receives a touch event.
  # When this class was constructed in GameViewController. A property was
  # set that linked this scene with the parent (being the GameViewController).
  # Using this wireup, we are telling GameViewController to present scene three.
  def touchesBegan touches, withEvent: _
    root.present_scene_three
  end

  def add_sprite x, y, path
    # Sprites are created using a texture. So first we have to create a
    # texture from the png in the /resources directory.
    texture = SKTexture.textureWithImageNamed path

    # Then we can create the sprite and set it's location.
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    addChild sprite
    sprite
  end

  # This method is invoked by SpriteKit. Generally speaking, the currentTime isn't really used.
  # iOS devices are designed to have a fixed framerate of 60. If there is a frame rate drop. SpriteKit
  # will attempt to catch up. There are times when the OS will decide to run your game at 30 fps. Which,
  # again is rare. Don't get too worried about performance of framerates. Just assume that your game will
  # run at 60 fps and do all your computation according to this framerate. The `update` method is the heart
  # of a sprite kit scene.
  #
  # Oh and also. The simulator is really bad at mantaining 60 fps and shouldn't be used as an indicator
  # to how your app will perform. You'll have to enroll in the Apple Developer program to deploy to an
  # actual device (which costs $99 per year). If you start getting serious with your game, definitely
  # sign up for the program and start deploying to a real device.
  def update currentTime
    @square.zRotation += 0.1
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
