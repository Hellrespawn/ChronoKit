local constants = require("src.constants")

local M = {}

local function parse_fraction(s)
	local num, den = s:match("^(%d+)/(%d+)$")
	assert(num and den, "Invalid fraction: " .. s)
	return tonumber(num) / tonumber(den)
end

function M.build_speed_table()
	local max       = settings.global[constants.SETTING_MAX_SPEED].value
	local min       = parse_fraction(settings.global[constants.SETTING_MIN_SPEED].value)
	local start     = settings.global[constants.SETTING_START_FACTOR].value
	local increment = settings.global[constants.SETTING_STEP_INCREMENT].value

	local slower    = {}
	local s, ratio  = 1, start
	while true do
		s = s / ratio
		if s < min then break end
		table.insert(slower, s)
		ratio = ratio + increment
	end

	local faster = {}
	s, ratio = 1, start
	while true do
		s = s * ratio
		if s > max then break end
		table.insert(faster, s)
		ratio = ratio + increment
	end

	local result = {}
	for i = #slower, 1, -1 do table.insert(result, slower[i]) end
	table.insert(result, 1)
	for _, v in ipairs(faster) do table.insert(result, v) end

	storage.one_index   = #slower + 1
	storage.speed_table = result
end

local function reset_state()
	storage.speed_index          = storage.one_index
	storage.previous_speed_index = nil
end

function M.init_storage()
	M.build_speed_table()
	reset_state()
	storage.mod_enabled = storage.mod_enabled ~= false
	storage.damage_action = storage.damage_action or constants.DAMAGE_ACTION_RESET
end

function M.reset_to_normal()
	M.build_speed_table()
	reset_state()
	game.speed = 1
end

local function save_speed()
	storage.previous_speed_index = storage.speed_index
end

local function apply_speed(index)
	storage.speed_index = index
	game.speed = storage.speed_table[index]
end

local function restore_previous()
	local target = storage.previous_speed_index or storage.one_index
	apply_speed(target)
end

function M.handle_play_pause()
	if game.tick_paused then
		restore_previous()
		game.tick_paused = false
	else
		save_speed()
		apply_speed(storage.one_index)
		game.tick_paused = true
	end
end

function M.handle_slower()
	if game.tick_paused then
		apply_speed(storage.one_index)
		game.tick_paused = false
	elseif storage.speed_index > 1 then
		local new_index = storage.speed_index - 1
		apply_speed(new_index)
		if new_index == storage.one_index then
			storage.previous_speed_index = nil
		end
	end
end

function M.handle_faster()
	if game.tick_paused then
		apply_speed(storage.one_index)
		game.tick_paused = false
	elseif storage.speed_index < #storage.speed_table then
		local new_index = storage.speed_index + 1
		apply_speed(new_index)
		if new_index == storage.one_index then
			storage.previous_speed_index = nil
		end
	end
end

function M.handle_speed_button()
	if game.tick_paused then
		restore_previous()
		game.tick_paused = false
	elseif storage.speed_index == storage.one_index then
		local prev = storage.previous_speed_index
		if prev and prev ~= storage.one_index then
			apply_speed(prev)
		end
	else
		save_speed()
		apply_speed(storage.one_index)
	end
end

return M
