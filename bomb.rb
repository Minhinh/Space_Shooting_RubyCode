# -------------------------------------- MISSILE ----------------------------------------------------
class Missile
  # Heart move speed goes down
  SPEED = 5
  attr_reader :x, :y, :angle, :radius
  def initialize(window, x, y)
    @radius = 25
    @img_bomb = Gosu::Image.new("image/boom.png") 
    @window = window
    @x = x
    @y = y
  end

  def draw
    @img_bomb.draw(@x, @y, 0)
  end

  def move
    @y += SPEED
    if @y > @window.height
      @window.missiles.delete(self)
    end
  end
end