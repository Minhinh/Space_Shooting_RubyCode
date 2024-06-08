# -------------------------------------- EXPLOSION ----------------------------------------------------
class Explosion
    attr_reader :finished
    def initialize(window, x, y)
        @x = x
        @y = y 
        @finished = false
        @radius = 30
        @img = Gosu::Image.load_tiles('image/explosion.png', 60, 60)
        @img_inc = 0 
    end

    def draw
        if @img_inc < @img.count
            @img[@img_inc].draw(@x - @radius, @y - @radius, 2)
            @img_inc += 1
        else
            @finished = true
        end
    end
end
# -------------------------------------- BULLET ----------------------------------------------------
class Bullet
    SPEED = 5
    attr_reader :x, :y, :radius
    def initialize(window, x, y, angle)
        @x = x
        @y = y
        @dir = angle
        @img = Gosu::Image.new('image/bullet.png')
        @radius = 3
        @window = window
    end

    def move
        @x += Gosu.offset_x(@dir, SPEED)
        @y += Gosu.offset_y(@dir, SPEED)
    end

    def draw
        @img.draw(@x - @radius, @y - @radius, 1)
    end
    def onscreen?
        right = @window.width + @radius
        left = -@radius
        top = -@radius
        bottom = @window.height + @radius
        @x > left and @x < right and @y > top and @y < bottom
    end
end