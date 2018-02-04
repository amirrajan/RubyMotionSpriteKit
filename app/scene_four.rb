class SceneFour < SKScene
  include ScreenSizes

  attr_accessor :root

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    # Add instructions for this scene.
    add_label <<-HERE
    There are two concepts shown in this scene.

    One of them is buttons.

    The other one is particle effects.

    Open scene_four.rb and read the code. Play around with it and change the particle properties to see what they do.

    To jump to this scene, you can type $controller.present_scene_four into the repl.

    To have an even faster feedback loop. Instead of running `rake`, run `ruby auto-build.rb`. Everytime you save a file, the app will automatically be rebuilt.

    To have an EVEN FASTER feedback loop, add $controller.present_scene_four to top_level.rb.

    Tap with two fingers (option + tap in simulator) to load the next scene.
    HERE

    # Spoiler alert. Buttons are just sprites. Everything is a sprite. Everything.
    @button_1 = add_sprite(50, 40, 'button.png', 'button 1')
    @button_2 = add_sprite(device_screen_width.fdiv(2), 40, 'button.png', 'button 2')
    @button_3 = add_sprite(device_screen_width - 50, 40, 'button.png', 'button 3')
  end

  def touchesBegan touches, withEvent: _
    # This is how you get the node at a specific location that was touched.
    node = nodeAtPoint(touches.allObjects.first.locationInNode(self))

    # once you have the node location, you can look at its name to determine what you want to do with the node.
    case node.name
    when 'button 1'
      particle_1
      @button_1.xScale = 2
      @button_1.yScale = 2
    when 'button 2'
      particle_2
      @button_2.xScale = 2
      @button_2.yScale = 2
    when 'button 3'
      particle_3
      @button_3.xScale = 2
      @button_3.yScale = 2
    end

    return unless touches.allObjects.count > 1

    root.present_scene_five
  end

  # Use caution with particles, they are expensive to create and run.
  def particle_1
    if @particle_1
      @particle_1.resetSimulation
    else
      @particle_1 = SKEmitterNode.alloc.init
      @particle_1.setParticleTexture SKTexture.textureWithImageNamed('tiny-square.png')
      @particle_1.setNumParticlesToEmit 200
      @particle_1.setParticleBirthRate 450
      @particle_1.setEmissionAngleRange 360
      @particle_1.setParticleSpeed 1000
      @particle_1.setParticleLifetimeRange 0.5
      @particle_1.setParticleAlphaSpeed(-0.5)
      @particle_1.setPosition CGPointMake(device_screen_width.fdiv(2), device_screen_height.fdiv(3))
      @particle_1.setParticleRotation 0.1
      @particle_1.setParticleRotationRange 6
      @particle_1.setParticlePositionRange CGVectorMake(10, 10)
      @particle_1.setParticleBlendMode SKBlendModeAlpha
      addChild @particle_1
    end
  end

  # Use caution with particles, they are expensive to create and run.
  def particle_2
    if @particle_2
      @particle_2.resetSimulation
    else
      @particle_2 = SKEmitterNode.alloc.init
      @particle_2.setParticleTexture SKTexture.textureWithImageNamed('tiny-square.png')
      @particle_2.setNumParticlesToEmit 50
      @particle_2.setParticleBirthRate 50
      @particle_2.setEmissionAngleRange 360
      @particle_2.setParticleSpeed 30
      @particle_2.setParticleLifetime 10
      @particle_2.setParticleLifetimeRange 20
      @particle_2.setParticleAlphaSpeed(-0.5)
      @particle_2.setPosition CGPointMake(device_screen_width.fdiv(2), device_screen_height.fdiv(3))
      @particle_2.setParticleRotation 0.1
      @particle_2.setParticleRotationRange 6
      @particle_2.setParticlePositionRange CGVectorMake(120, 120)
      @particle_2.setParticleBlendMode SKBlendModeAlpha
      addChild @particle_2
    end
  end

  # Use caution with particles, they are expensive to create and run.
  def particle_3
    if @particle_3
      @particle_3.resetSimulation
    else
      @particle_3 = SKEmitterNode.alloc.init
      @particle_3.setParticleTexture SKTexture.textureWithImageNamed('tiny-square.png')
      @particle_3.setNumParticlesToEmit 25
      @particle_3.particleBirthRate = 20
      @particle_3.particleLifetime = 3
      @particle_3.emissionAngle = 3.14159 / 2.0
      @particle_3.emissionAngleRange = 3.14159 / 3.0
      @particle_3.particleSpeed = 90
      @particle_3.yAcceleration = -70
      @particle_3.particleAlphaSpeed = -0.3
      @particle_3.setPosition CGPointMake(device_screen_width.fdiv(2), device_screen_height.fdiv(3))
      @particle_3.setParticlePositionRange(CGVectorMake(10, 10))
      @particle_3.particleBlendMode = SKBlendModeAlpha
      addChild @particle_3
    end
  end

  def update _
    bring_node_to_target_scale @button_1
    bring_node_to_target_scale @button_2
    bring_node_to_target_scale @button_3
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
    wrapped_text = wrap 38, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(10,
                                   device_screen_height - 50 - ((i + 1) * font_size))
      addChild label
    end
  end

  def add_sprite x, y, path, name
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    sprite.name = name
    addChild sprite
    sprite
  end
end
