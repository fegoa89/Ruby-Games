class Player

  attr_reader :x, :y, :angle, :radius

  def initialize(window)
    @x = 200
    @y = 200
    @angle = 0
    @image = Gosu::Image.new('assets/images/ship.png')
    @velocity_x = 0
    @velocity_y = 0
    @radius = 20
    @window = window
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_right
    @angle += 3
  end

  def turn_left
    @angle -= 3
  end

  def accelerate
    # offset methods returns the X / Y component of a vector
    # of angle theta and magnitude r, or the total distance
    # covered by moving r pixels in the direction given by angle theta.
    @velocity_x += Gosu.offset_x(@angle, 2)
    @velocity_y += Gosu.offset_y(@angle, 2)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= 0.9
    @velocity_y *= 0.9
    limit_player_movement
  end

  def limit_player_movement
    if @x > @window.width - @radius
      @velocity_x = 0
      @x = @window.width - @radius
    end

    if @x < @radius
      @velocity_x = 0
      @x = @radius
    end

    if @y > @window.height - @radius
      @velocity_y = 0
      @y = @window.height - @radius
    end
  end
end