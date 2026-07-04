local constants = require("src.constants")
local gui       = require("src.gui")
local speed     = require("src.speed")

local M         = {}

local function cycle_damage_action(delta)
	local order = constants.DAMAGE_ACTION_ORDER
	local n     = #order
	for i, value in ipairs(order) do
		if value == storage.damage_action then
			return order[((i - 1 + delta) % n) + 1]
		end
	end
	return order[1]
end

function M.handle_cycle()
	storage.damage_action = cycle_damage_action(1)
end

function M.handle_cycle_reverse()
	storage.damage_action = cycle_damage_action(-1)
end

function M.on_entity_damaged(event)
	-- This has no event filter, so it fires for every damaged entity on every force.
	-- Check the cheap, entity-independent conditions first so the common case (normal
	-- speed) bails out without touching event.entity/.force at all.
	if game.speed <= 1 then return end
	if storage.damage_action == constants.DAMAGE_ACTION_NONE then return end
	if event.entity.force.name ~= "player" then return end

	local pos = event.entity.position
	local gps = string.format("[gps=%d,%d,%s]", pos.x, pos.y, event.entity.surface.name)
	local message

	if storage.damage_action == constants.DAMAGE_ACTION_PAUSE then
		speed.handle_play_pause()
		message = { "mod-messages.chronokit-message-game-paused", gps }
	else
		speed.handle_speed_button()
		message = { "mod-messages.chronokit-message-speed-reset", gps }
	end

	gui.update_guis()
	for _, player in pairs(game.connected_players) do
		player.print(message)
	end
end

return M
