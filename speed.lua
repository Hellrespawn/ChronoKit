local constants = require("constants")

local M = {}

local function unpause_to_normal()
	game.tick_paused = false
	game.speed = 1
end

function M.save_speed()
	storage.speed_mem = game.speed
end

function M.handle_playpause()
	if game.tick_paused then
		game.speed = storage.speed_mem
	else
		M.save_speed()
		game.speed = 1
	end
	game.tick_paused = not game.tick_paused
end

function M.handle_slower()
	if game.tick_paused then
		unpause_to_normal()
	elseif game.speed >= 0.2 then
		game.speed = game.speed / 2
		if game.speed ~= 1 then M.save_speed() end
	end
end

function M.handle_faster()
	if game.tick_paused then
		unpause_to_normal()
	elseif game.speed < settings.global[constants.SETTING_MAX_SPEED].value then
		game.speed = game.speed * 2
		if game.speed ~= 1 then M.save_speed() end
	end
end

function M.handle_speed_button()
	if game.tick_paused then
		game.speed = storage.speed_mem
		game.tick_paused = false
	elseif game.speed == 1 then
		game.speed = storage.speed_mem
	else
		game.speed = 1
	end
end

return M
