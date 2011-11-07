love.graphics.setMode( 0, 0, false, false, 8)

SCREEN_W = love.graphics.getWidth()
SCREEN_H = love.graphics.getHeight()
--math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )	
math.randomseed(os.time())
zoom_in = 1
zoom_out = 1
scale = .5

function love.load()
	planetgen(20)
	player = {
		pos = {x= SCREEN_W/2, y = SCREEN_H/2},
		width = 25,
		height = 25,	
		v = {x =200, y = 200},
		r = 0
	}
end

function love.update(dt)
	if love.keyboard.isDown('left') then
		player.r = player.r - 2*math.pi*dt
	end
	
	if love.keyboard.isDown('right') then
		player.r = player.r +2*math.pi*dt
	end
	
	if love.keyboard.isDown ('up') then
		player.pos.x = player.pos.x + player.v.x*math.cos(player.r)*dt
		player.pos.y = player.pos.y + player.v.y*math.sin(player.r)*dt
	end
	
		planet_move(planets.x, planets.y)
end

function love.draw()	
	
	love.graphics.setBackgroundColor( 255, 255, 255, 0)
	love.graphics.scale(scale, scale)
	
	love.graphics.setColor(0,0,0,100)	
	for i,v in ipairs(planets) do
		love.graphics.setColor(v.c.r, v.c.g, v.c.b, v.c.a)
		love.graphics.circle("fill", v.x, v.y, v.r, 3*v.r)
	end
	
	love.graphics.push()
	love.graphics.translate(player.pos.x, player.pos.y)
	love.graphics.rotate(player.r)
	love.graphics.translate(-player.pos.x, -player.pos.y)
	
	love.graphics.rectangle ('fill',
		player.pos.x-player.width/2,
		player.pos.y-player.height/2,
		player.width, player.height
	)
	
	love.graphics.pop()
	
end

function love.mousepressed(x,y, button)
	if button == "wu" then
		scale = scale +scale / 4
	elseif button == "wd" then
		scale = scale- scale / 4
	end
end

function planetgen(number)

	planets={}
		for i = 0, number do
			planetu = {}
			planetu.r = math.random(SCREEN_H/40, SCREEN_H/20)
			planetu.x = math.random(SCREEN_W)
			planetu.y = math.random(SCREEN_H)
			planetu.c = {
				r = math.random(255),
				g = math.random(255),
				b = math.random(255),
				a = math.random(100, 200)
			}
			table.insert(planets, planetu)
		end
end

function glowShape( r, g, b, type, ...)
	love.graphics.setColor(r, g, b, 15)
	
	for i = 7, 2, -1 do
		if i == 2 then 
			i = 1
			love.graphics.setColor(r, g, b, 255)
		end
		
		love.graphics.setLineWidth(i)
		
		if type == "line" then
			love.graphics[type](...)
		else
			love.graphics[type]("fill", ...)
		end
	end
end

function planet_move()
	for j,k in ipairs(planets) do
		for i,v in ipairs(planets) do
			if j ~= i then
				if ((math.sqrt((k.x-v.x)^2+(k.y-v.y)^2)) < 200)  then
					
					sideA = k.y - v.y
					sideB = k.x - v.x 
					
					local ang = math.tan(sideB, sideA) --+ math.pi/8
					local a = math.acos(ang)
					local b = math.asin(ang)

					v.x = v.x + b
					v.y = v.y +a
				end
			else i = i+1
			end
		end
	end
end