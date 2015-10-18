require 'gosu'
require 'pry'
class Main < Gosu::Window
  def initialize
    super(800, 600)
    self.caption   = "Whack !"
    @ruby          = Gosu::Image.new("assets/images/ruby.png")
    @x             = 200
    @y             = 200
    @width         = 50
    @height        = 43
    @velocity_x    = 5
    @velocity_y    = 5
    @visible       = 0
    @hammer        = Gosu::Image.new("assets/images/hammer.png")
    @hit           = 0
    @font          = Gosu::Font.new(30)
    @score         = 0
    @playing       = true
    @start_time    = 0
    @level_number  = 0
    @minimum_score = 15
  end

  def draw
    draw_ruby
    draw_hammer
    evaluate_hit_result
    info_messages
    game_status
  end

  def update
    if @playing
      manage_velocity
      manage_visibility
      manage_time
    end
  end

  def game_status
    unless @playing
      if user_won_actual_level?
        go_to_next_level
      else
        play_again
      end
    end
  end

  def go_to_next_level
    @font.draw("You won Level : #{@level_number} !", 275, 300, 3)
    @font.draw("Your score : #{@score}.", 300, 350, 3)
    @font.draw("Press 'C' to play on the next level.", 200, 400, 3)
    @font.draw("Press the space bar to start again.", 200, 450, 3)
    @visible = 20
  end

  def play_again
    @font.draw("Game Over", 330, 300, 3)
    @font.draw("Press the space bar to play again", 200, 350, 3)
    @visible = 20
  end

  def info_messages
    @font.draw("Level : "          + @level_number.to_s, 30, 10, 2)
    @font.draw("Seconds left : "   + @time_left.to_s, 30, 30, 2)
    @font.draw("Score : "          + @score.to_s, 30, 50, 2)
    @font.draw("Score to reach : " + @minimum_score.to_s, 30, 70, 2)
  end

  def user_won_actual_level?
    @score >= @minimum_score
  end

  def draw_ruby
    if @visible > 0
      @ruby.draw(@x - @width / 2, @y - @height / 2, 1)
    end
  end

  def evaluate_hit_result
    if @hit == 0
      color = Gosu::Color::NONE
    elsif @hit == 1
      color = Gosu::Color::GREEN
    elsif @hit == -1
      color = Gosu::Color::RED
    end
    
    draw_quad(0, 0, color, 800, 0, color, 800, 600, color, 0, 600, color)
    @hit = 0
  end

  def draw_hammer
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)
  end

  def manage_time
    @time_left = ( 30 - (( Gosu.milliseconds - @start_time ) / 1000) )
    @playing = false if @time_left < 0
  end

  def manage_velocity
    @x          += @velocity_x
    @y          += @velocity_y
    @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
    @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
  end

  def manage_visibility
    @visible -= 1
    @visible = 30 if @visible < -10 && rand < 0.01
  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 5     
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if (user_won_actual_level? && id == 6)
        @level_number  += 1
        @playing        = true
        @visible        = -10
        @start_time     = Gosu.milliseconds
        @score          = 0
        @minimum_score += 5
      elsif (id == Gosu::KbSpace)
        @level_number  = 1
        @playing       = true
        @visible       = -10
        @start_time    = Gosu.milliseconds
        @score         = 0
        @level_number  = 0
        @minimum_score = 5
      end
    end
  end
end

Main.new.show