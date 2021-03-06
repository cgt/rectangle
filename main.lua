push = require "push"

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

VW = 640
VH = 480

function love.load()
	math.randomseed(os.time())

	love.graphics.setDefaultFilter('nearest', 'nearest')
	push:setupScreen(VW, VH, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	score_font = love.graphics.newFont(40)

	frames = 0
	tooClose = false
	o = {}
	o.x = 30
	o.y = 30
	o.w = 15
	o.h = 15
	next_update = 0
	frame_size = 25
	green_box_frame = -1
	score = 0
	direction = {}
	direction.xn = 1
	direction.yn = 1
	direction.x = 1
	direction.y = 1
	direction.last_changed = 0
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.mousepressed(x, y)
	x, y = push:toGame(x, y)
	distx = math.abs(x-o.x)
	disty = math.abs(y-o.y)
	if distx < o.w and disty < o.h then
		green_box_frame = frames
		score = score + 1
		which = math.random(0, 1)
		if which == 1 then
			direction.x = math.random(4, 8)
		else
			direction.y = math.random(4, 8)
		end
		direction.last_changed = frames
	end
end

function love.update(dt)
	frames = frames + 1

	x, y = push:toGame(love.mouse.getPosition())
	distx = math.abs(x-o.x)
	disty = math.abs(y-o.y)
	if not tooClose and distx < o.w*2 and disty < o.h*2 then
		next_update = frames + math.random(20)
		tooClose = true
	elseif tooClose and frames == next_update then
		tooClose = false
		next_update = false
		which = math.random(0, 1)
		if which == 1 then
			direction.x = direction.x + math.random(0.75, 1)
		else
			direction.y = direction.y + math.random(0.75, 1)
		end
		direction.last_changed = frames
	elseif direction.last_changed < frames-60 then
		which = math.random(0, 1)
		if which == 1 then
			direction.x = math.random(2)
		else
			direction.y = math.random(2)
		end
		direction.last_changed = frames
	end
	o.x = o.x + direction.x * direction.xn
	o.y = o.y + direction.y * direction.yn
	if o.x+o.w > VH-frame_size then
		direction.xn = -1
	elseif o.x < frame_size then
		direction.xn = 1
	end
	if o.y+o.h > VH-frame_size then
		direction.yn = -1
	elseif o.y < frame_size then
		direction.yn = 1
	end
end

function love.draw()
	push:start()

	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', 0, 0, VW, VH)

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', frame_size, frame_size, VW-frame_size*2, VH-frame_size*2)

	if green_box_frame ~= -1 and green_box_frame > frames-120 then
		love.graphics.setColor(0, 128, 0)
	elseif tooClose then
		love.graphics.setColor(255, 191, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle('fill', o.x, o.y, o.w, o.h)

	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(score_font)
	love.graphics.print(score)

	push:finish()
end
