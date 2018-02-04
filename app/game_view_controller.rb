# coding: utf-8
class GameViewController < UIViewController
  include ScreenSizes

  # This hides the status bar.
  def prefersStatusBarHidden
    true
  end

  # This hides iPhone X's notch thingy at the bottom.
  def prefersHomeIndicatorAutoHidden
    true
  end

  # When the code in app_delegate is successfully executed,
  # this method is invoked. Here is where we create and present
  # our scenes.
  def viewDidLoad
    super
    self.view = sk_view
    # The first time the app is loaded. Present scene one.
    present_scene_zero
    $controller = self
  end

  def present_scene_zero
    @scene_zero = SceneZero.sceneWithSize(sk_view.frame.size)
    @scene_zero.root = self
    sk_view.presentScene @scene_zero
  end

  def present_scene_one
    @scene_one = SceneOne.sceneWithSize(sk_view.frame.size)
    @scene_one.root = self
    sk_view.presentScene @scene_one
  end

  def present_scene_two
    @scene_two = SceneTwo.sceneWithSize(sk_view.frame.size)
    @scene_two.root = self
    sk_view.presentScene @scene_two
  end

  def present_scene_three
    @scene_three = SceneThree.sceneWithSize(sk_view.frame.size)
    @scene_three.root = self
    sk_view.presentScene @scene_three
  end

  def present_scene_four
    @scene_four = SceneFour.sceneWithSize(sk_view.frame.size)
    @scene_four.root = self
    sk_view.presentScene @scene_four
  end

  def present_scene_five
    @scene_five = SceneFive.sceneWithSize(sk_view.frame.size)
    @scene_five.root = self
    sk_view.presentScene @scene_five
  end

  def present_scene_six
    @scene_five = SceneSix.sceneWithSize(sk_view.frame.size)
    @scene_five.root = self
    sk_view.presentScene @scene_five
  end

  def sk_view
    @sk_view ||= SKView.alloc.initWithFrame screen_rect
  end
end
