class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # This is the container for your game. A UIViewController is a
    # UIKit control. There isn't much UIKit you need to know for building games,
    # just make a mental note that this thing is what will house all of the scenes
    # to your game.
    @game_view_controller = GameViewController.new

    # This keeps the iOS device from going to sleep (you wouldn't want the device
    # to autolock while watching a cut scene.
    UIApplication.sharedApplication.setIdleTimerDisabled true

    # This is boiler plate code that sets up the GameViewController so that it
    # takes up the entire screen.
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @game_view_controller
    @window.makeKeyAndVisible

    # Returning true from this function signifies that the app was successfully launched.
    true
  end
end
