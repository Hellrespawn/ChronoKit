local constants = require("constants")
local gui       = require("gui")
local speed     = require("speed")
local damage    = require("damage")

------------------------------------------------------------
local function init_globals()
	storage.speed_mem = storage.speed_mem or settings.global[constants.SETTING_MAX_SPEED].value
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
	if event.setting ~= constants.SETTING_MAX_SPEED then return end
	local max_speed = settings.global[constants.SETTING_MAX_SPEED].value
	if storage.speed_mem > max_speed then
		storage.speed_mem = max_speed
		if game.speed > max_speed then
			game.speed = max_speed
			gui.update_guis()
		end
	end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)

------------------------------------------------------------
local function on_gui_click(event)
	if not event.element.name:find("chronokit_", 1, true) then return end

	local player = game.players[event.player_index]

	if player.admin then
		if event.element.name == "chronokit_button_playpause" then
			speed.handle_playpause()
		elseif event.element.name == "chronokit_button_slower" then
			speed.handle_slower()
		elseif event.element.name == "chronokit_button_faster" then
			speed.handle_faster()
		elseif event.element.name == "chronokit_button_speed" then
			speed.handle_speed_button()
		end
		gui.update_guis()
	else
		player.print({"mod-messages.chronokit-message-admins-only"})
	end
end

script.on_event(defines.events.on_gui_click, on_gui_click)

------------------------------------------------------------
script.on_event(defines.events.on_entity_damaged, damage.on_entity_damaged)
