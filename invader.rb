# -------------------------------------- INVADER ----------------------------------------------------
class Invader
    SPEED = 3
    attr_reader :x, :y, :radius
    def initialize(window, x, y)
        @radius = 25
        # 20 sang 25
        @x = rand(window.width - 2* @radius) + @radius
        @y = 0 # start at the top
        @img = Gosu::Image.load_tiles('image/enemy.png', 42, 44) # pixel 
        @img_inc = 0
    end

    def draw
        if @img_inc < @img.count
            @img[@img_inc].draw(@x - @radius, @y - @radius, 1)
            @img_inc += 1
        else
            @img_inc = 0
        end  
    end

    def move
        @y += SPEED
    end
end