local constants        = require("constants")

local M                = {}

local GUI_NAME         = "chronokit_gui"
local INNER_NAME       = "chronokit_inner"
local BUTTON_PLAY_PAUSE = "chronokit_button_play_pause"
local BUTTON_SLOWER    = "chronokit_button_slower"
local BUTTON_FASTER    = "chronokit_button_faster"
local BUTTON_SPEED     = "chronokit_button_speed"

local SPRITE_PAUSE     = "chronokit_pause"
local SPRITE_PLAY      = "chronokit_play"

local function update_gui(player)
	local outer = player.gui.top[GUI_NAME]
	if not outer then return end
	local inner = outer[INNER_NAME]

	if game.tick_paused then
		inner[BUTTON_SPEED].caption          = "x0.0"
		inner[BUTTON_SPEED].style.font_color = constants.colors.white
		inner[BUTTON_PLAY_PAUSE].sprite       = SPRITE_PAUSE
	elseif game.speed == 1 then
		local prev                           = storage.previous_speed_index
		local no_saved                       = (prev == nil or prev == storage.one_index)
		inner[BUTTON_SPEED].caption          = "x1.0"
		inner[BUTTON_SPEED].style.font_color = no_saved and constants.colors.gray or constants.colors.white
		inner[BUTTON_PLAY_PAUSE].sprite       = SPRITE_PLAY
	elseif game.speed < 1 then
		inner[BUTTON_SPEED].caption          = string.format("/%1.1f", 1 / game.speed)
		inner[BUTTON_SPEED].style.font_color = constants.colors.green
		inner[BUTTON_PLAY_PAUSE].sprite       = SPRITE_PLAY
	else
		inner[BUTTON_SPEED].caption          = string.format("x%1.1f", game.speed)
		inner[BUTTON_SPEED].style.font_color = constants.colors.red
		inner[BUTTON_PLAY_PAUSE].sprite       = SPRITE_PLAY
	end
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
		font_color = constants.colors.white,
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
