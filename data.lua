local BUTTON_SIZE = 36

data:extend(
	{
		{
			type   = "font",
			name   = "chronokit_font_bold",
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
	}
)

local default_gui = data.raw["gui-style"].default

default_gui.chronokit_sprite_style =
{
	type           = "button_style",
	parent         = "button",
	top_padding    = 1,
	right_padding  = 0,
	bottom_padding = 0,
	left_padding   = 0,
	width          = BUTTON_SIZE,
	height         = BUTTON_SIZE,
	scalable       = false,
}

default_gui.chronokit_playpause_style =
{
	type           = "button_style",
	parent         = "button",
	top_padding    = -2,
	right_padding  = -2,
	bottom_padding = -2,
	left_padding   = -2,
	width          = BUTTON_SIZE,
	height         = BUTTON_SIZE,
	scalable       = true,
}

default_gui.chronokit_flow_style =
{
	type                = "horizontal_flow_style",
	parent              = "horizontal_flow",
	top_padding         = 5,
	bottom_padding      = 5,
	left_padding        = 5,
	right_padding       = 5,

	horizontal_spacing  = 0,
	vertical_spacing    = 0,
	max_on_row          = 0,
	resize_row_to_width = true,

	graphical_set       = { type = "none" },
}

default_gui.chronokit_button_style =
{
	type             = "button_style",
	parent           = "button",
	font             = "chronokit_font_bold",
	align            = "center",
	top_padding      = 1,
	bottom_padding   = 0,
	left_padding     = 3,
	right_padding    = 3,
	height           = BUTTON_SIZE,
	minimal_width    = BUTTON_SIZE,
	scalable         = false,
	left_click_sound = "__core__/sound/gui-click.ogg",
}
