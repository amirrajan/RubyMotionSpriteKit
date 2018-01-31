module ScreenSizes
  def iPhone4?
    UIScreen.mainScreen.bounds.size.height < 568
  end

  def iPhone5?
    UIScreen.mainScreen.bounds.size.height == 568
  end

  def iPhone6Plus?
    UIScreen.mainScreen.bounds.size.height == 736
  end

  def iPhone6?
    UIScreen.mainScreen.bounds.size.height == 667
  end

  def iPad?
    UIScreen.mainScreen.bounds.size.height == 1024
  end

  def iPhoneX?
    UIScreen.mainScreen.bounds.size.height == 812
  end

  def device_screen_width
    UIScreen.mainScreen.bounds.size.width
  end

  def device_screen_height
    UIScreen.mainScreen.bounds.size.height
  end

  def screen_rect
    CGRectMake(0, 0, device_screen_width, device_screen_height)
  end
end
