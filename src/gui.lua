local constants         = require("src.constants")

local M                 = {}

local GUI_NAME            = "chronokit_gui"
local INNER_NAME          = "chronokit_inner"
local BUTTON_SPEED_CONTROL = "chronokit_button_speed_control"
local BUTTON_SPEED        = "chronokit_button_speed"
local BUTTON_DAMAGE_ACTION = "chronokit_button_damage_action"

local SPRITE_PAUSE        = "chronokit_pause"
local SPRITE_PLAY         = "chronokit_play"
local SPRITE_SLOWER       = "chronokit_backward_arrow"
local SPRITE_FASTER       = "chronokit_forward_arrow"

local DAMAGE_ACTION_SPRITES = {
	[constants.DAMAGE_ACTION_NONE]  = "chronokit_damage_none",
	[constants.DAMAGE_ACTION_RESET] = "chronokit_damage_reset",
	[constants.DAMAGE_ACTION_PAUSE] = "chronokit_damage_pause",
}

local DAMAGE_ACTION_LOCALE_KEYS = {
	[constants.DAMAGE_ACTION_NONE]  = "mod-tooltips.chronokit-damage-action-none",
	[constants.DAMAGE_ACTION_RESET] = "mod-tooltips.chronokit-damage-action-reset",
	[constants.DAMAGE_ACTION_PAUSE] = "mod-tooltips.chronokit-damage-action-pause",
}

local function color_to_rich_text(c)
	return string.format("%g,%g,%g", c.r, c.g, c.b)
end

-- Factorio caps LocalisedString concatenation at 20 parameters per level, and
-- `parts` here can exceed that (its length tracks the user-configurable speed
-- table). Nest every 19 entries under a continuation slot to stay under the cap.
local function localised_concat(parts)
	if #parts <= 20 then
		return { "", table.unpack(parts) }
	end
	local head = {}
	for i = 1, 19 do
		head[i] = parts[i]
	end
	local tail = {}
	for i = 20, #parts do
		tail[#tail + 1] = parts[i]
	end
	head[20] = localised_concat(tail)
	return { "", table.unpack(head) }
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

local SPEED_BUCKET_SLOWER = "slower"
local SPEED_BUCKET_FASTER = "faster"
local SPEED_BUCKET_NORMAL = "normal"

local function speed_bucket(s)
	if s < 1 then
		return SPEED_BUCKET_SLOWER
	elseif s > 1 then
		return SPEED_BUCKET_FASTER
	else
		return SPEED_BUCKET_NORMAL
	end
end

local function get_speed_color()
	local bucket = speed_bucket(game.speed)
	if bucket == SPEED_BUCKET_SLOWER then
		return constants.colors.green
	elseif bucket == SPEED_BUCKET_FASTER then
		return constants.colors.red
	else
		return get_font_color()
	end
end

local function build_speed_tooltip()
	local parts  = {}
	local tbl    = storage.speed_table
	local one    = storage.one_index
	local cur    = storage.speed_index
	local paused = game.tick_paused

	local function speed_color(s)
		local bucket = speed_bucket(s)
		if bucket == SPEED_BUCKET_SLOWER then
			return TOOLTIP_COLOR_GREEN
		elseif bucket == SPEED_BUCKET_FASTER then
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

	local function paused_entry(active)
		if active then
			return { "", "[font=default-bold][color=" .. TOOLTIP_COLOR_WHITE .. "]", { "mod-tooltips.chronokit-speed-paused" }, "[/color][/font]" }
		else
			return { "mod-tooltips.chronokit-speed-paused" }
		end
	end

	for i = 1, #tbl do
		if i == one then
			table.insert(parts, paused_entry(paused))
			table.insert(parts, "\n")
		end
		local s = tbl[i]
		table.insert(parts, entry(format_speed(s), not paused and i == cur, speed_color(s)))
		if i < #tbl then
			table.insert(parts, "\n")
		end
	end

	return localised_concat(parts)
end

local function build_damage_action_tooltip()
	local order = constants.DAMAGE_ACTION_ORDER
	return {
		"mod-tooltips.chronokit-damage-action",
		{ DAMAGE_ACTION_LOCALE_KEYS[storage.damage_action] },
		{ DAMAGE_ACTION_LOCALE_KEYS[order[1]] },
		{ DAMAGE_ACTION_LOCALE_KEYS[order[2]] },
		{ DAMAGE_ACTION_LOCALE_KEYS[order[3]] },
	}
end

local function get_speed_control_sprite()
	if game.tick_paused then
		return SPRITE_PAUSE
	end
	local bucket = speed_bucket(game.speed)
	if bucket == SPEED_BUCKET_SLOWER then
		return SPRITE_SLOWER
	elseif bucket == SPEED_BUCKET_FASTER then
		return SPRITE_FASTER
	else
		return SPRITE_PLAY
	end
end

local function build_speed_control_tooltip()
	return { "mod-tooltips.chronokit-speed-control" }
end

local function update_gui(player)
	local outer = player.gui.top[GUI_NAME]
	if not outer then return end
	local inner = outer[INNER_NAME]

	if game.tick_paused then
		inner[BUTTON_SPEED].caption          = "x0.0"
		inner[BUTTON_SPEED].style.font_color = constants.colors.white
	else
		inner[BUTTON_SPEED].caption          = format_speed(game.speed)
		inner[BUTTON_SPEED].style.font_color = get_speed_color()
	end

	inner[BUTTON_SPEED].tooltip = build_speed_tooltip()

	inner[BUTTON_SPEED_CONTROL].sprite  = get_speed_control_sprite()
	inner[BUTTON_SPEED_CONTROL].tooltip = build_speed_control_tooltip()

	inner[BUTTON_DAMAGE_ACTION].sprite = DAMAGE_ACTION_SPRITES[storage.damage_action]
	inner[BUTTON_DAMAGE_ACTION].tooltip = build_damage_action_tooltip()
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
		name   = BUTTON_SPEED_CONTROL,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_SPEED_CONTROL },
		style  = "chronokit_sprite_style",
		sprite = SPRITE_PLAY,
	})
	inner.add({
		type       = "button",
		name       = BUTTON_SPEED,
		tags       = { mod = constants.MOD_TAG, action = constants.ACTION_SPEED },
		caption    = "",
		font_color = get_font_color(),
		style      = "chronokit_button_style",
	})
	inner.add({
		type   = "sprite-button",
		name   = BUTTON_DAMAGE_ACTION,
		tags   = { mod = constants.MOD_TAG, action = constants.ACTION_DAMAGE_ACTION },
		style  = "chronokit_sprite_style",
		sprite = DAMAGE_ACTION_SPRITES[storage.damage_action],
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
