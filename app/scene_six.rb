class SceneSix < SKScene
  include ScreenSizes

  attr_accessor :root, :game_pad

  # A little helper method that can be used to get the camera in the repl.
  def get_camera
    @camera
  end

  def get_game
    @game
  end

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    @game_pad = {}

    #initalize a camera, all sprites go into the camera
    @camera = Camera.new self
    @camera.pin_to_bottom_middle

    $scene = self

    @game = SceneSixGame.new

    $game = @game

    @ship = add_sprite(0, 0, 'square.png', 'ship', @camera.main_layer)
  end

  def touchesBegan touches, withEvent: _
    touch = touches.allObjects.first.locationInNode(self)

    if touch.x < device_screen_width.fdiv(2)
      @game_pad = { left: :down }
    else
      @game_pad = { right: :down }
    end
  end

  def touchesEnded touches, withEvent: _
    @game_pad = { }
  end

  def update _
    if @game_pad[:left] == :down
      @game.target_x = @game.target_x - 10
    elsif @game_pad[:right] == :down
      @game.target_x = @game.target_x + 10
    end
    @game.update
    @camera.update
    @ship.position = CGPointMake(@game.ship_x, @game.ship_y)
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
