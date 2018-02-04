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
    self.physicsWorld.gravity = CGVectorMake(0, 0)
    self.physicsWorld.contactDelegate = self
    self.view.showsPhysics = true

    @game_pad = {}

    #initalize a camera, all sprites go into the camera
    @camera = Camera.new self
    @camera.pin_to_bottom_middle

    $scene = self

    @game = SceneSixGame.new

    $game = @game

    @ship = add_sprite(0, 0, 'square.png', 'ship', @camera.main_layer)

    @bullet = add_sprite(-5000, 0, 'tiny-square.png', 'bullet', @camera.main_layer)
    @bullet.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize @bullet.frame.size
    @bullet.zPosition = @ship.zPosition - 1
    @bullet.physicsBody.dynamic = true
    @bullet.physicsBody.categoryBitMask = 2
    @bullet.physicsBody.contactTestBitMask = 4

    @enemy_sprites = []

    @game.enemies.each do |e|
      @enemy_sprites << add_enemy_sprite(e[:id], e[:x], e[:y])
    end
  end

  def add_enemy_sprite(id, x, y)
    enemy = add_sprite(x, y, 'square.png', 'enemy', @camera.main_layer)
    enemy.name = id
    enemy.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize enemy.frame.size
    enemy.physicsBody.dynamic = true
    enemy.physicsBody.categoryBitMask = 4
    enemy.physicsBody.contactTestBitMask = 2
    enemy
  end

  def touchesBegan touches, withEvent: _
    touch = touches.allObjects.first.locationInNode(self)

    if touch.x < device_screen_width.fdiv(2)
      @game_pad = { left: :down }
    else
      @game_pad = { right: :down }
    end
  end

  def didBeginContact contact
    if contact.bodyA.node == @bullet
      @game.enemy_was_hit(contact.bodyB.node.name)
    else
      @game.enemy_was_hit(contact.bodyA.node.name)
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

    if @game.bullet_location_y && @game.bullet_location_x
      @bullet.position = CGPointMake(@game.bullet_location_x, @game.bullet_location_y)
    else
      @bullet.position = CGPointMake(-5000, -5000)
    end

    @enemy_sprites.each do |e|
      e.position = CGPointMake(-5000, -5000)
    end

    @game.enemies.each do |e|
      node = @camera.main_layer.childNodeWithName(e[:id])
      node && node.position = CGPointMake(e[:x], e[:y])
    end
  end

  def add_sprite x, y, path, name, parent
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    sprite.name = name
    parent.addChild sprite
    sprite
  end
end
