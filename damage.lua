local constants = require("constants")
local gui       = require("gui")
local speed     = require("speed")

local M = {}

function M.on_entity_damaged(event)
	if event.entity.force.name ~= "player" then return end
	if game.speed <= 1 then return end

	local pos = event.entity.position
	local gps = string.format("[gps=%d,%d,%s]", pos.x, pos.y, event.entity.surface.name)
	local message

	if settings.global[constants.SETTING_DAMAGE_ACTION].value == constants.DAMAGE_ACTION_PAUSE then
		speed.handle_playpause()
		message = {"mod-messages.chronokit-message-game-paused", gps}
	else
		speed.handle_speed_button()
		message = {"mod-messages.chronokit-message-speed-reset", gps}
	end

	gui.update_guis()
	for _, player in pairs(game.connected_players) do
		player.print(message)
	end
end

return M
