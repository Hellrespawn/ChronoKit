local constants        = require("constants")

local M                = {}

local GUI_NAME         = "chronokit_gui"
local BUTTON_PLAYPAUSE = "chronokit_button_playpause"
local BUTTON_SLOWER    = "chronokit_button_slower"
local BUTTON_FASTER    = "chronokit_button_faster"
local BUTTON_SPEED     = "chronokit_button_speed"

local SPRITE_PAUSE     = "utility/pause"
local SPRITE_PLAY      = "utility/play"

function M.create_gui(player)
	local gui = player.gui.top[GUI_NAME]

	if gui then
		gui.destroy()
	end

	gui = player.gui.top.add({
		type      = "flow",
		name      = GUI_NAME,
		direction = "horizontal",
		style     = "chronokit_flow_style",
	})

	gui.add({
		type   = "sprite-button",
		name   = BUTTON_PLAYPAUSE,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_PLAYPAUSE },
		style  = "chronokit_playpause_style",
		sprite = game.tick_paused and SPRITE_PAUSE or SPRITE_PLAY,
	})
	gui.add({
		type   = "sprite-button",
		name   = BUTTON_SLOWER,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_SLOWER },
		sprite = "utility/backward_arrow_black",
		style  = "chronokit_sprite_style",
	})
	gui.add({
		type   = "sprite-button",
		name   = BUTTON_FASTER,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_FASTER },
		sprite = "utility/forward_arrow_black",
		style  = "chronokit_sprite_style",
	})
	gui.add({
		type       = "button",
		name       = BUTTON_SPEED,
		tags       = { mod = constants.MOD_TAG, action = constants.ACTION_SPEED },
		caption    = "x1.0",
		font_color = constants.colors.white,
		style      = "chronokit_button_style",
	})

	return gui
end

function M.update_guis()
	for _, player in pairs(game.connected_players) do
		local gui = M.create_gui(player)

		if game.tick_paused then
			gui[BUTTON_SPEED].caption          = "x0.0"
			gui[BUTTON_SPEED].style.font_color = constants.colors.white
			gui[BUTTON_PLAYPAUSE].sprite       = SPRITE_PAUSE
		elseif game.speed == 1 then
			local prev                         = storage.previous_speed_index
			local no_saved                     = (prev == nil or prev == storage.one_index)
			gui[BUTTON_SPEED].caption          = "x1.0"
			gui[BUTTON_SPEED].style.font_color = no_saved and constants.colors.gray or constants.colors.white
			gui[BUTTON_PLAYPAUSE].sprite       = SPRITE_PLAY
		elseif game.speed < 1 then
			gui[BUTTON_SPEED].caption          = string.format("/%1.1f", 1 / game.speed)
			gui[BUTTON_SPEED].style.font_color = constants.colors.green
			gui[BUTTON_PLAYPAUSE].sprite       = SPRITE_PLAY
		else
			gui[BUTTON_SPEED].caption          = string.format("x%1.1f", game.speed)
			gui[BUTTON_SPEED].style.font_color = constants.colors.red
			gui[BUTTON_PLAYPAUSE].sprite       = SPRITE_PLAY
		end
	end
end

return M
