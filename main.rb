require 'gosu'
require_relative 'heart'
require_relative 'bomb'
require_relative 'invader'
require_relative 'explosion'
require_relative 'player'
# ------------------------------------- SpaceWar main ---------------------------------------- 
class SpaceWar < Gosu::Window
    INVADER_FREQUENCY = 10
    def initialize
        @window_width = 800
        @window_height = 600
        super(@window_width, @window_height, false)
        self.caption = "Space War"
        #Images  inserted into game
        @begin_image = Gosu::Image.new("image/begin_screen.png", tileable: true)  
        @background_image = Gosu::Image.new("image/background.png", tileable: true) 
        @minion = Gosu::Image.new("image/minion.png", tileable: true) 
        @instructions_image = Gosu::Image.new("image/Instruction.png", tileable: true)
        @scene = :start
        @background_y = 0
        @background_speed = 1
        @info_font = Gosu::Font.new(20)

        #Animation in start screen
        @hover_start = false
        @hover_instructions = false

        #Sound inserted in game
        @background_sound = Gosu::Song.new("sound/background_sound.wav")
        @bonus_life = Gosu::Sample.new("sound/bonus_life.mp3")
        @explosion_sound = Gosu::Sample.new("sound/explosion.mp3")
        @shooting_sound = Gosu::Sample.new("sound/shoot.wav")
        @background_sound.volume = 1
        @background_sound.play(true)
    end

    def initialize_game
        @player = Player.new(self)
        @invaders = []
        @bullets = []
        @explosions = []
        @missiles = []
        @hearts = []
        @scene = :game 
        @background_y = 0
        @background_speed = 1.5
        @invader_timer = 0
        @invader_interval = 100 # spawning time invader (30 - 100)
        @background_image = Gosu::Image.new("image/background.png", tileable: true)  
        @heart_img = Gosu::Image.new("image/heart.png")
        @hearts_life = 3
    end
# finished screen win and lose
    def initialize_end
        @mission_sucess_image = Gosu::Image.new("image/mission_sucess.png")
        @mission_fail_image = Gosu::Image.new("image/mission_fail.png")
    end

    def draw_end
        if @hearts_life >= 15
            @mission_sucess_image.draw(0, 0, 0)
        else
            @mission_fail_image.draw(0, 0, 0)
        end
    end

    def draw
        case @scene
            # scene : start and scene : game 
            #start screen
        when :start
            draw_start
        when :game
            draw_game
            #end screen
        when :end
            draw_end
        end
    end

    def draw_start
        #track mouse 
        # @info_font.draw("mouse_y: #{mouse_y}", 200, 550, 3, 1.0, 1.0, Gosu::Color::WHITE)
        # @info_font.draw("mouse_x: #{mouse_x}", 20, 550, 3, 1.0, 1.0, Gosu::Color::WHITE)

        # -------- Make the background image moving ---------
        @background_image.draw(0, @background_y, 0, @window_width.to_f / @background_image.width, 1)
        @background_image.draw(0, @background_y - @background_image.height, 0, @window_width.to_f / @background_image.width, 1)
        @begin_image.draw(0, 0, 0)

        # -------- Draw missile in the start screen with hover animation ---------
        if @hover_start
            @minion.draw(15,306,0)
        end

        if @hover_instructions
            @minion.draw(15,400,0)
        end

        # -------- Handle instructions window ---------
        if @instructions_visible 
            @instructions_image.draw(0, 0, 0)
        end
    end
    # ----------------------------------------------
    def draw_game
        @player.draw
        # -------- Draw the invaders in the screen ---------
        @invaders.each do |invader|
            invader.draw
        end
        # -------- Draw the bullets in the screen ---------
        @bullets.each do |bullet|
            bullet.draw
        end
        # -------- Draw the explosion in the screen ---------
        @explosions.each do |explosion|
            explosion.draw
        end
        # -------- Make the backgr movin in Game screen ---------
        @background_image.draw(0, @background_y, 0, @window_width.to_f / @background_image.width, 1)
        @background_image.draw(0, @background_y - @background_image.height, 0, @window_width.to_f / @background_image.width, 1)

        # -------- Draw remaining hearts(lives left) ---------
        heart_spacing = 1
        heart_start_x = self.width - (@heart_img.width + heart_spacing) * @hearts_life
        heart_y = 20

        @hearts_life.times do |i|
            heart_x = heart_start_x + i * (@heart_img.width + heart_spacing)
            @heart_img.draw(heart_x, heart_y, 0)
        end
        # -------- Draw the missiles falling down ---------
        @missiles.each do |missile|
            missile.draw
        end
        # -------- Draw the hearts falling down ---------
        @hearts.each do |heart|
            heart.draw
        end
        
    end
    # ----------------------------------------------
    def update
        case @scene 
        when :start
            update_start
        when :game
            update_game
        end
    end
    # ----------------------------------------------
    def button_down(id)
        case @scene
        when :start
            button_down_start(id)
        when :game
            button_down_game(id)
        when :end
            button_down_end(id)
        end
    end
    # ----------------------------------------------
    def button_down_start(id)
        if @hover_start
            initialize_game
        end
        # -------- Make Instructions window appear ---------
        if @hover_instructions
            @instructions_visible = true
        end
        if @hover_return
            @instructions_visible = false   
        end
    end

    def button_down_game(id)
        if id == Gosu::KbSpace
            @bullets.push Bullet.new(self, @player.x + 50, @player.y + 25, @player.angle)
            @shooting_sound.play
        end
    end

    def button_down_end(id) 
        if id == Gosu::KbH
            initialize
        end
    end

    def update_start
        # -------- Animation for background ---------
        @background_y += @background_speed
        @background_y %= @background_image.height
        # -------- Indicate START button ---------
        # 85, 340   187, 361
        if ((mouse_x > 85 and mouse_x < 187) and (mouse_y > 340 and mouse_y < 361))
            @hover_start = true
          else
            @hover_start = false
        end

        # -------- Indicate INSTRUCTIONS button ---------
        # 85, 434    317, 456
        if ((mouse_x > 85 and mouse_x < 317) and (mouse_y > 434 and mouse_y < 456))
            @hover_instructions = true
          else
            @hover_instructions = false
        end

        # -------- Indicate RETURN button ---------
        # 34,33      69, 90
        if ((mouse_x > 34 and mouse_x < 69) and (mouse_y > 33 and mouse_y < 90))
            @hover_return = true
          else
            @hover_return = false
        end
    end
	# ----------------------------------------------
    def update_game
        if @hearts_life >= 15
            @scene = :end
            initialize_end
        end
        # ------------ Player movement --------------
        @player.move_right if button_down?(Gosu::KbRight)
        @player.move_left if button_down?(Gosu::KbLeft)
        @player.move

        # ------------ Invader movement --------------
        @invaders.each { |invader| invader.move }
        @invader_timer += 1
        if @invader_timer >= @invader_interval
        # condition timer > number of frame interval needs before a new invader is added 
            @invaders.push Invader.new(self, 100, 100)
            @invader_timer = 0 # a new invader is added and reset 
            @invader_interval -= 1 if @invader_interval > 10 # Decrease the interval over time
            # make the game harder
        end

        # ------------ Bullet movement --------------
        @bullets.each do |bullet|
            bullet.move
        end
        # -------- Collision between INVADER & BULLET ---------
        @invaders.dup.each do |invader|
            @bullets.dup.each do |bullet|
                distance = Gosu.distance(invader.x, invader.y, bullet.x, bullet.y)
                if distance < invader.radius + bullet.radius
                    @invaders.delete invader
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, invader.x, invader.y)
                    @explosion_sound.play
                    # -----------------------------------------------------------------------------
                    # Create HEART & MISSILE dropping from the exploded invader's position randomly
                    random_number = rand
                    if random_number < 0.5 # < 0.5
                    missile = Missile.new(self, invader.x, invader.y)
                    @missiles.push(missile)
                    elsif random_number > 0.5 # > 0.5
                    heart = Heart.new(self, invader.x, invader.y)
                    @hearts.push(heart)
                    end
                end
            end
        end
        # --------- Background moving ----------
        @background_y += @background_speed
        @background_y %= @background_image.height
        # ----------- Missile moving down -----------
        @missiles.each do |missile|
            missile.move
            @missiles.delete(missile) if missile.y > @window_height
        end
        # ----------- Heart moving down -----------
        @hearts.each do |heart|
            heart.move
            @hearts.delete(heart) if heart.y > @window_height
        end
        # -------- Collision between INVADER & PLAYER ---------
        @invaders.dup.each do |invader|
            distance = Gosu.distance(invader.x, invader.y, @player.x, @player.y)
            if distance < invader.radius + @player.radius
                @invaders.delete(invader)
                @explosions.push Explosion.new(self, invader.x, invader.y)
                @explosion_sound.play
                # ----------------------------------------------
                # Reduce the number of hearts
                @hearts_life -= 1
                # ----------------------------------------------
                # End screen indication
                if @hearts_life.zero?
                    # Player has lost all hearts, end the game
                    @scene = :end
                    initialize_end
                else
                    # Create a new player instance
                    @player = Player.new(self)
                end
            end
        end

        # -------- Collision between MISSILE & PLAYER ---------
        @missiles.dup.each do |missile|
            distance = Gosu.distance(missile.x, missile.y, @player.x, @player.y)
            if distance < missile.radius + @player.radius
                @missiles.delete(missile)
                @explosions.push Explosion.new(self, missile.x, missile.y)
                @explosion_sound.play
        
                # Reduce the number of hearts
                @hearts_life -= 1
        
                if @hearts_life.zero?
                    # Player has lost all hearts, end the game
                    @scene = :end
                    initialize_end
                else
                    # Create a new player instance
                    @player = Player.new(self)
                end
            end
        end
        # -------- Collision between HEART & PLAYER ---------
        @hearts.dup.each do |heart|
            distance = Gosu.distance(heart.x, heart.y, @player.x, @player.y)
            if distance < heart.radius + @player.radius
                @hearts.delete(heart)
                @bonus_life.play
                @hearts_life += 1
            end
        end
    end
        def missiles
            @missiles
        end
        def hearts
            @hearts
        end
end
window = SpaceWar.new
window.show

