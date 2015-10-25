require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
class Main < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Spaceships Battles"
    @player = Player.new(self)
    @enemies = []
    @bullets = []
  end

  def draw
    @player.draw
    draw_enemies
    draw_bullets
  end

  def update
    manage_player_movement
    manage_enemies_movement
    manage_bullets_movement
  end

  def manage_enemies_movement
    if rand < 0.01
      @enemies.push(Enemy.new(self))
    end

    @enemies.each do |enemy|
      enemy.move
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

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end
end

Main.new.show