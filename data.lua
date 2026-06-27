data:extend(
	{
		{
			type   = "font",
			name   = "chronokit_font",
			from   = "default-bold",
			border = false,
			size   = 15
		},
		{
			type         = "sprite",
			name         = "chronokit_pause",
			filename     = "__ChronoKit__/graphics/pause.png",
			size         = 32,
			mipmap_count = 2,
			flags        = { "gui-icon" },
		},
		{
			type         = "sprite",
			name         = "chronokit_play",
			filename     = "__ChronoKit__/graphics/play.png",
			size         = 32,
			mipmap_count = 2,
			flags        = { "gui-icon" },
		},
		{
			type         = "sprite",
			name         = "chronokit_backward_arrow",
			filename     = "__ChronoKit__/graphics/backward-arrow.png",
			size         = 32,
			mipmap_count = 2,
			flags        = { "gui-icon" },
		},
		{
			type         = "sprite",
			name         = "chronokit_forward_arrow",
			filename     = "__ChronoKit__/graphics/forward-arrow.png",
			size         = 32,
			mipmap_count = 2,
			flags        = { "gui-icon" },
		},
		{
			type            = "shortcut",
			name            = "chronokit-toggle",
			action          = "lua",
			toggleable      = true,
			icon            = "__ChronoKit__/graphics/clock.png",
			icon_size       = 32,
			small_icon      = "__ChronoKit__/graphics/clock.png",
			small_icon_size = 32,
		},
	}
)

local default_gui = data.raw["gui-style"].default

default_gui.chronokit_sprite_style =
{
	type    = "button_style",
	parent  = "slot_button",
	size    = 28,
}

default_gui.chronokit_button_style =
{
	type             = "button_style",
	parent           = "slot_button",
	font             = "chronokit_font",
	align            = "center",
	height           = 28,
	minimal_width    = 54,
	left_padding     = 3,
	right_padding    = 3,
	left_click_sound = "__core__/sound/gui-click.ogg",
}
