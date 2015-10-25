class Bullet
  def initialize(window, x, y, angle)
    @x = x
    @y = y
    @direction = angle
    @image = Gosu::Image.new('assets/images/bullet.png')
    @radius = 3
    @window = window
  end

  def move
    @x += Gosu.offset_x(@direction, 5)
    @y += Gosu.offset_y(@direction, 5)
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end