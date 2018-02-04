class SceneOne < SKScene
  include ScreenSizes

  attr_accessor :root

  # This method is invoked when a scene is presented.
  def didMoveToView _
    # Set the aspect ratio.
    self.scaleMode = SKSceneScaleModeAspectFit

    $scene = self

    # Set the background color to white.
    self.backgroundColor = UIColor.whiteColor

    # Add a label to the scene.
    # A little bit of context. The primary class that is used to construct a label
    # is called SKLabelNode. Unfortunately, SKLabelNode does not support multiline text,
    # so some supporting classes have been included to help you create multiline labels,
    # specifically StringWrapper and the `add_label` method. Fun huh?
    add_label <<-HERE
    Sweet. You got the application running. Welcome to the horrible mess that is called SpriteKit.

    I'm kidding it isn't that bad (this template will definitely make your life better). Let's get started.

    1. The entry point to an iOS app is app_delegate.rb. There are a few lines in there.

    2. The primary line you want to look at is the initialization of GameViewController.

    3. Read app_delegate.rb and all the great comments. Cool?

    4. Now jump over to game_view_controller.rb. Read that file too.

    5. The prefer.* methods hide ansillary iOS UI and makes your game full screen.

    6. The present_scene_one method is where the magic happens for presenting this scene.

    7. Open scene_one.rb and read the code there.

    8. Alrighty let's do something a bit more interesting then just displaying some text.

    9. Tap anywhere to load the next scene.
    HERE
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
      label.position = CGPointMake(3, device_screen_height - 50 - ((i + 1) * font_size))
      addChild label
    end
  end

  # This delegate is invoked when the scene receives a touch event.
  # When this class was constructed in GameViewController. A property was
  # set that linked this scene with the parent (being the GameViewController).
  # Using this wireup, we are telling GameViewController to present scene two.
  def touchesBegan touches, withEvent: _
    root.present_scene_two
  end
end
