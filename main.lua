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

	frames = 0
	tooClose = false
	ox = 30
	oy = 30
	ow = 15
	oh = 15
	next_update = 0
	won = false
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.mousepressed(x, y)
	x, y = push:toGame(x, y)
	distx = math.abs(x-ox)
	disty = math.abs(y-oy)
	if distx < ow and disty < oh then
		won = true
	end
end

function love.update(dt)
	frames = frames + 1

	if not won then
		x, y = push:toGame(love.mouse.getPosition())
		distx = math.abs(x-ox)
		disty = math.abs(y-oy)
		if not tooClose and distx < ow*2 and disty < oh*2 then
			next_update = frames + math.random(20)
			tooClose = true
		elseif tooClose and frames == next_update then
			tooClose = false
			next_update = false
			ox = math.random(VW-20)
			oy = math.random(VH-20)
		end
	end
end

function love.draw()
	push:start()

	if won then
		love.graphics.setColor(0, 255, 0)
	elseif tooClose then
		love.graphics.setColor(255, 191, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle('fill', ox, oy, ow, oh)

	push:finish()
end
