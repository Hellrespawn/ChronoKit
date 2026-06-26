local constants = require("constants")
local gui       = require("gui")
local speed     = require("speed")
local damage    = require("damage")

------------------------------------------------------------
local function init_globals()
	speed.init_storage()
end

------------------------------------------------------------
local function init_player(player)
	if player.connected then
		gui.build_gui(player)
	end
end

------------------------------------------------------------
local function init_players()
	for _, player in pairs(game.players) do
		init_player(player)
	end
end

------------------------------------------------------------
local function on_init()
	init_globals()
	init_players()
end

script.on_init(on_init)

------------------------------------------------------------
local function on_configuration_changed(data)
	if data.mod_changes["ChronoKit"] ~= nil then
		init_globals()
		init_players()
		gui.update_guis()
	end
end

script.on_configuration_changed(on_configuration_changed)

------------------------------------------------------------
local function on_player_init(event)
	init_player(game.players[event.player_index])
end

script.on_event({defines.events.on_player_created, defines.events.on_player_joined_game}, on_player_init)

------------------------------------------------------------
local function on_runtime_mod_setting_changed(event)
	local watched = {
		[constants.SETTING_MAX_SPEED]      = true,
		[constants.SETTING_MIN_SPEED]      = true,
		[constants.SETTING_START_FACTOR]   = true,
		[constants.SETTING_STEP_INCREMENT] = true,
	}
	if not watched[event.setting] then return end
	speed.reset_to_normal()
	gui.update_guis()
end

script.on_event(defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)

------------------------------------------------------------
local action_handlers = {
	playpause = speed.handle_playpause,
	slower    = speed.handle_slower,
	faster    = speed.handle_faster,
	speed     = speed.handle_speed_button,
}

local function on_gui_click(event)
	local tags = event.element.tags
	if tags.mod ~= "chronokit" then return end

	local player = game.players[event.player_index]

	if player.admin then
		local handler = action_handlers[tags.action]
		if handler then handler() end
		gui.update_guis()
	else
		player.print({"mod-messages.chronokit-message-admins-only"})
	end
end

script.on_event(defines.events.on_gui_click, on_gui_click)

------------------------------------------------------------
script.on_event(defines.events.on_entity_damaged, damage.on_entity_damaged)
