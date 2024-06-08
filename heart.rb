# -------------------------------------- HEART -------------------------------------------------
class Heart
    # Heart move speed goes down
    SPEED = 5
    attr_reader :x, :y, :angle, :radius
    # xóa angle
    def initialize(window, x, y)
      @radius = 25
      @img = Gosu::Image.new("image/heart_shield.png") # Replace with your single image file
      @window = window
      @x = x
      @y = y
    end

    def draw
      @img.draw(@x, @y, 0)
    end

    def move
      @y += SPEED
      if @y > @window.height
        @window.missiles.delete(self)
      end
    end
  end