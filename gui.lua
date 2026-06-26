local constants = require("constants")

local M = {}

function M.build_gui(player)
	local gui = player.gui.top.chronokit_flow

	if gui and gui.chronokit_button_playpause == nil then
		gui.destroy()
		gui = nil
	end

	if gui == nil then
		gui = player.gui.top.add({
			type = "flow",
			name = "chronokit_flow",
			direction = "horizontal",
			style = "chronokit_flow_style",
		})
		gui.add({
			type = "sprite-button",
			name = "chronokit_button_playpause",
			style = "chronokit_sprite_style",
			sprite = game.tick_paused and "utility/pause" or "utility/play",
		})
		gui.add({type = "button", name = "chronokit_button_slower", caption = "<",  font_color = constants.colors.white, style = "chronokit_button_style"})
		gui.add({type = "button", name = "chronokit_button_faster", caption = ">",  font_color = constants.colors.white, style = "chronokit_button_style"})
		gui.add({type = "button", name = "chronokit_button_speed",  caption = "x1", font_color = constants.colors.white, style = "chronokit_button_style"})
	end
	return gui
end

function M.update_guis()
	for _, player in pairs(game.connected_players) do
		local flow = M.build_gui(player)

		if game.tick_paused then
			flow.chronokit_button_speed.caption = "x0"
			flow.chronokit_button_speed.style.font_color = constants.colors.white
			flow.chronokit_button_playpause.sprite = "utility/pause"
		elseif game.speed == 1 then
			flow.chronokit_button_speed.caption = "x1"
			flow.chronokit_button_speed.style.font_color = constants.colors.white
			flow.chronokit_button_playpause.sprite = "utility/play"
		elseif game.speed < 1 then
			flow.chronokit_button_speed.caption = string.format("/%1.0f", 1 / game.speed)
			flow.chronokit_button_speed.style.font_color = constants.colors.green
			flow.chronokit_button_playpause.sprite = "utility/play"
		else
			flow.chronokit_button_speed.caption = string.format("x%1.0f", game.speed)
			flow.chronokit_button_speed.style.font_color = constants.colors.lightred
			flow.chronokit_button_playpause.sprite = "utility/play"
		end
	end
end

return M
