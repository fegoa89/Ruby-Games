class Enemy
  def initialize(window)
    @radius = 20
    @x = rand(window.width - 2 * @radius) + @radius
    @y = 0
    @image = Gosu::Image.new('assets/images/enemy.png')
  end

  def move
    @y += 4
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end