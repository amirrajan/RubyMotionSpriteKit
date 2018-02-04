class SceneZero < SKScene
  attr_accessor :root

  # This is what's called when a scene comes into view.
  def didMoveToView _
    # Initialize a counter variable.
    @counter = 0

    self.backgroundColor = UIColor.whiteColor

    # Add instruction labels to the scene
    label_zero = SKLabelNode.labelNodeWithText "HELLO WORLD."
    label_zero.fontName = 'Courier'
    label_zero.fontColor = UIColor.blackColor
    label_zero.fontSize = 16
    label_zero.position = CGPointMake(3, device_screen_height - 70)
    label_zero.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild label_zero

    label_one = SKLabelNode.labelNodeWithText "READ EVERYTHING. I'M SERIOUS."
    label_one.fontName = 'Courier'
    label_one.fontColor = UIColor.blackColor
    label_one.fontSize = 16
    label_one.position = CGPointMake(3, device_screen_height - 70 - 70)
    label_one.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild label_one

    label_two = SKLabelNode.labelNodeWithText "NO RLY. FOLLOW. INSTRUCTIONS."
    label_two.fontName = 'Courier'
    label_two.fontColor = UIColor.blackColor
    label_two.fontSize = 16
    label_two.position = CGPointMake(3, device_screen_height - 70 - 70 - 70)
    label_two.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild label_two

    label_three = SKLabelNode.labelNodeWithText "READ THE CODE IN scene_zero.rb."
    label_three.fontName = 'Courier'
    label_three.fontColor = UIColor.blackColor
    label_three.fontSize = 16
    label_three.position = CGPointMake(3, device_screen_height - 70 - 70 - 70 - 70)
    label_three.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild label_three

    label_four = SKLabelNode.labelNodeWithText "TAP WHEN THE COUNTER IS PAST #{60 * 15}."
    label_four.fontName = 'Courier'
    label_four.fontColor = UIColor.blackColor
    label_four.fontSize = 16
    label_four.position = CGPointMake(3, device_screen_height - 70 - 70 - 70 - 70 - 70)
    label_four.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild label_four

    @label_counter = SKLabelNode.labelNodeWithText ""
    @label_counter.fontName = 'Courier'
    @label_counter.fontColor = UIColor.blackColor
    @label_counter.fontSize = 16
    @label_counter.position = CGPointMake(3, device_screen_height - 70 - 70 - 70 - 70 - 70 - 70)
    @label_counter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
    addChild @label_counter
  end

  def touchesBegan touches, withEvent: _
    return if @counter < 60 * 15

    root.present_scene_one
  end

  def update _
    @counter += 1

    if @counter < 60 * 15
      @label_counter.text = "#{@counter}"
    else
      @label_counter.text = "#{@counter} OKAY. NOW YOU CAN TAP."
    end
  end

  def device_screen_width
    UIScreen.mainScreen.bounds.size.width
  end

  def device_screen_height
    UIScreen.mainScreen.bounds.size.height
  end
end
