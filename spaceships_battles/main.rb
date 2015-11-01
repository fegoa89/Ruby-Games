require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'

class Main < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Spaceships Battles"
    @player      = Player.new(self)
    @enemies     = []
    @bullets     = []
    @explosions  = []
  end

  def draw
    @player.draw
    draw_enemies
    draw_bullets
    draw_explosions
  end

  def update
    manage_player_movement
    manage_enemies_movement
    manage_bullets_movement
    manage_collisions
    manage_explosions
  end

  def manage_enemies_movement
    if rand < 0.01
      @enemies.push(Enemy.new(self))
    end

    @enemies.each do |enemy|
      enemy.move
    end

    @enemies.dup.each do |enemy|
      if enemy.y > 800 + enemy.radius
        @enemies.delete enemy
      end
    end
  end

  def draw_enemies
    @enemies.each do |enemy|
      enemy.draw
    end
  end

  def draw_bullets
    @bullets.each do |bullet|
      bullet.draw
    end

    @bullets.dup.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end
  end

  def draw_explosions
    @explosions.each do |explosion|
      explosion.draw
    end
  end

  def manage_player_movement
    @player.turn_left  if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
  end

  def manage_bullets_movement
    @bullets.each do |bullet|
      bullet.move
    end
  end

  def manage_collisions
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
        end
      end
    end
  end

  def manage_explosions
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end
end

Main.new.show