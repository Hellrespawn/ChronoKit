local constants = require("constants")

local M = {}

local FLOW_NAME     = "chronokit_flow"
local BTN_PLAYPAUSE = "chronokit_button_playpause"
local BTN_SLOWER    = "chronokit_button_slower"
local BTN_FASTER    = "chronokit_button_faster"
local BTN_SPEED     = "chronokit_button_speed"

local SPRITE_PAUSE = "utility/pause"
local SPRITE_PLAY  = "utility/play"

function M.build_gui(player)
	local gui = player.gui.top[FLOW_NAME]

	if gui and gui[BTN_PLAYPAUSE] == nil then
		gui.destroy()
		gui = nil
	end

	if gui == nil then
		gui = player.gui.top.add({
			type      = "flow",
			name      = FLOW_NAME,
			direction = "horizontal",
			style     = "chronokit_flow_style",
		})
		gui.add({
			type   = "sprite-button",
			name   = BTN_PLAYPAUSE,
			tags   = { mod = constants.MOD_TAG, action = constants.ACTION_PLAYPAUSE },
			style  = "chronokit_playpause_style",
			sprite = game.tick_paused and SPRITE_PAUSE or SPRITE_PLAY,
		})
		gui.add({
			type   = "sprite-button",
			name   = BTN_SLOWER,
			tags   = { mod = constants.MOD_TAG, action = constants.ACTION_SLOWER },
			sprite = "utility/backward_arrow_black",
			style  = "chronokit_sprite_style",
		})
		gui.add({
			type   = "sprite-button",
			name   = BTN_FASTER,
			tags   = { mod = constants.MOD_TAG, action = constants.ACTION_FASTER },
			sprite = "utility/forward_arrow_black",
			style  = "chronokit_sprite_style",
		})
		gui.add({
			type       = "button",
			name       = BTN_SPEED,
			tags       = { mod = constants.MOD_TAG, action = constants.ACTION_SPEED },
			caption    = "x1",
			font_color = constants.colors.white,
			style      = "chronokit_button_style",
		})
	end
	return gui
end

function M.update_guis()
	for _, player in pairs(game.connected_players) do
		local flow = M.build_gui(player)

		if game.tick_paused then
			flow[BTN_SPEED].caption           = "x0"
			flow[BTN_SPEED].style.font_color  = constants.colors.white
			flow[BTN_PLAYPAUSE].sprite        = SPRITE_PAUSE
		elseif game.speed == 1 then
			local prev     = storage.previous_speed_index
			local no_saved = (prev == nil or prev == storage.one_index)
			flow[BTN_SPEED].caption           = "x1"
			flow[BTN_SPEED].style.font_color  = no_saved and constants.colors.gray or constants.colors.white
			flow[BTN_PLAYPAUSE].sprite        = SPRITE_PLAY
		elseif game.speed < 1 then
			flow[BTN_SPEED].caption           = string.format("/%1.0f", 1 / game.speed)
			flow[BTN_SPEED].style.font_color  = constants.colors.green
			flow[BTN_PLAYPAUSE].sprite        = SPRITE_PLAY
		else
			flow[BTN_SPEED].caption           = string.format("x%1.0f", game.speed)
			flow[BTN_SPEED].style.font_color  = constants.colors.lightred
			flow[BTN_PLAYPAUSE].sprite        = SPRITE_PLAY
		end
	end
end

return M
