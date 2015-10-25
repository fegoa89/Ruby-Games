require 'gosu'
require_relative 'player'
require_relative 'enemy'

class Main < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Spaceships Battles"
    @player = Player.new(self)
    @enemies = []
  end

  def draw
    @player.draw
    draw_enemies
  end

  def update
    manage_player_movement
    manage_enemies_movement
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

  def manage_player_movement
    @player.turn_left  if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
  end
end

Main.new.show