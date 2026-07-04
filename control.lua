local constants = require("src.constants")
local gui       = require("src.gui")
local speed     = require("src.speed")
local damage    = require("src.damage")

local function mod_enabled()
	return storage.mod_enabled ~= false
end

local function init_player(player)
	if not player.connected then return end

	player.set_shortcut_toggled("chronokit-toggle", mod_enabled())

	if mod_enabled() then
		gui.create_gui(player)
	end
end

local function init_players()
	for _, player in pairs(game.players) do
		init_player(player)
	end
end

local function on_init()
	speed.init_storage()
	init_players()
end

local function on_configuration_changed(data)
	if data.mod_changes[constants.MOD_NAME] ~= nil then
		speed.init_storage()
		init_players()
	end
end

local function on_player_init(event)
	init_player(game.players[event.player_index])
end


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


local action_handlers = {
	[constants.ACTION_SPEED_CONTROL] = { forward = speed.handle_faster, reverse = speed.handle_slower, shift = speed.handle_play_pause },
	[constants.ACTION_SPEED]         = { forward = speed.handle_speed_button },
	[constants.ACTION_DAMAGE_ACTION] = { forward = damage.handle_cycle, reverse = damage.handle_cycle_reverse },
}

local function on_gui_click(event)
	local tags = event.element.tags
	if tags.mod ~= constants.MOD_TAG then return end

	local player = game.players[event.player_index]

	if player.admin then
		local entry = action_handlers[tags.action]
		if entry then
			local handler
			if event.shift and entry.shift then
				if event.button == defines.mouse_button_type.left then
					handler = entry.shift
				end
			elseif event.button == defines.mouse_button_type.right then
				handler = entry.reverse
			else
				handler = entry.forward
			end
			if handler then handler() end
		end
		gui.update_guis()
	else
		player.print({ "mod-messages.chronokit-message-admin-only" })
	end
end



local function on_lua_shortcut(event)
	if event.prototype_name ~= "chronokit-toggle" then return end
	local player = game.players[event.player_index]
	if not player.admin then
		player.print({ "mod-messages.chronokit-message-admin-only" })
		player.set_shortcut_toggled("chronokit-toggle", mod_enabled())
		return
	end
	storage.mod_enabled = not mod_enabled()
	if storage.mod_enabled then
		for _, p in pairs(game.connected_players) do
			gui.create_gui(p)
			p.set_shortcut_toggled("chronokit-toggle", true)
		end
	else
		speed.reset_to_normal()
		for _, p in pairs(game.connected_players) do
			gui.destroy_gui(p)
			p.set_shortcut_toggled("chronokit-toggle", false)
		end
	end
end

local function on_load()
	script.on_event(defines.events.on_tick, function()
		for _, player in pairs(game.connected_players) do
			player.set_shortcut_toggled("chronokit-toggle", mod_enabled())
		end
		script.on_event(defines.events.on_tick, nil)
	end)
end

script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_configuration_changed)

script.on_event({ defines.events.on_player_created, defines.events.on_player_joined_game }, on_player_init)
script.on_event(defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
script.on_event(defines.events.on_entity_damaged, damage.on_entity_damaged)
