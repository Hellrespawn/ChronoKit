local constants         = require("src.constants")

local M                 = {}

local GUI_NAME          = "chronokit_gui"
local INNER_NAME        = "chronokit_inner"
local BUTTON_PLAY_PAUSE = "chronokit_button_play_pause"
local BUTTON_SLOWER     = "chronokit_button_slower"
local BUTTON_FASTER     = "chronokit_button_faster"
local BUTTON_SPEED      = "chronokit_button_speed"

local SPRITE_PAUSE      = "chronokit_pause"
local SPRITE_PLAY       = "chronokit_play"

local function color_to_rich_text(c)
	return string.format("%g,%g,%g", c.r, c.g, c.b)
end

local TOOLTIP_COLOR_GREEN = color_to_rich_text(constants.colors.green)
local TOOLTIP_COLOR_RED   = color_to_rich_text(constants.colors.red)
local TOOLTIP_COLOR_WHITE = color_to_rich_text(constants.colors.white)

local function has_saved_speed()
	local prev = storage.previous_speed_index
	return prev ~= nil and prev ~= storage.one_index
end

local function get_font_color()
	return has_saved_speed() and constants.colors.white or constants.colors.gray
end

local function format_speed(s)
	if s < 1 then
		return string.format("/%1.1f", 1 / s)
	else
		return string.format("x%1.1f", s)
	end
end

local function get_speed_color()
	if game.speed < 1 then
		return constants.colors.green
	elseif game.speed > 1 then
		return constants.colors.red
	else
		return get_font_color()
	end
end

local function build_speed_tooltip()
	local lines  = {}
	local tbl    = storage.speed_table
	local one    = storage.one_index
	local cur    = storage.speed_index
	local paused = game.tick_paused

	local function speed_color(s)
		if s < 1 then
			return TOOLTIP_COLOR_GREEN
		elseif s > 1 then
			return TOOLTIP_COLOR_RED
		else
			return TOOLTIP_COLOR_WHITE
		end
	end

	local function entry(label, active, color)
		if active then
			return "[font=default-bold][color=" .. color .. "]" .. label .. "[/color][/font]"
		else
			return label
		end
	end

	for i = 1, #tbl do
		if i == one then
			table.insert(lines, entry("x0.0 (paused)", paused, TOOLTIP_COLOR_WHITE))
		end
		local s = tbl[i]
		table.insert(lines, entry(format_speed(s), not paused and i == cur, speed_color(s)))
	end

	return table.concat(lines, "\n")
end

local function update_gui(player)
	local outer = player.gui.top[GUI_NAME]
	if not outer then return end
	local inner = outer[INNER_NAME]

	if game.tick_paused then
		inner[BUTTON_SPEED].caption          = "x0.0"
		inner[BUTTON_SPEED].style.font_color = constants.colors.white
		inner[BUTTON_PLAY_PAUSE].sprite      = SPRITE_PAUSE
	else
		inner[BUTTON_SPEED].caption          = format_speed(game.speed)
		inner[BUTTON_SPEED].style.font_color = get_speed_color()
		inner[BUTTON_PLAY_PAUSE].sprite      = SPRITE_PLAY
	end

	inner[BUTTON_SPEED].tooltip = build_speed_tooltip()
end

function M.create_gui(player)
	local existing = player.gui.top[GUI_NAME]
	if existing then existing.destroy() end

	local outer = player.gui.top.add({
		type      = "frame",
		name      = GUI_NAME,
		direction = "horizontal",
		style     = "slot_window_frame",
	})

	local inner = outer.add({
		type      = "frame",
		name      = INNER_NAME,
		direction = "horizontal",
		style     = "mod_gui_inside_deep_frame",
	})

	inner.add({
		type   = "sprite-button",
		name   = BUTTON_PLAY_PAUSE,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_PLAY_PAUSE },
		style  = "chronokit_sprite_style",
		sprite = SPRITE_PLAY,
	})
	inner.add({
		type   = "sprite-button",
		name   = BUTTON_SLOWER,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_SLOWER },
		sprite = "chronokit_backward_arrow",
		style  = "chronokit_sprite_style",
	})
	inner.add({
		type   = "sprite-button",
		name   = BUTTON_FASTER,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_FASTER },
		sprite = "chronokit_forward_arrow",
		style  = "chronokit_sprite_style",
	})
	inner.add({
		type       = "button",
		name       = BUTTON_SPEED,
		tags       = { mod = constants.MOD_TAG, action = constants.ACTION_SPEED },
		caption    = "",
		font_color = get_font_color(),
		style      = "chronokit_button_style",
	})

	update_gui(player)
end

function M.update_guis()
	for _, player in pairs(game.connected_players) do
		update_gui(player)
	end
end

function M.destroy_gui(player)
	local existing = player.gui.top[GUI_NAME]
	if existing then existing.destroy() end
end

return M
