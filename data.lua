data:extend(
	{
		{
			type = "font",
			name = "chronokit_font_bold",
			from = "default-bold",
			border = false,
			size = 15
		},
	}
)

local default_gui = data.raw["gui-style"].default

default_gui.chronokit_sprite_style =
{
	type = "button_style",
	parent = "button",
	top_padding = 1,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	width = 36,
	height = 36,
	scalable = false,
}

default_gui.chronokit_playpause_style =
{
	type = "button_style",
	parent = "button",
	top_padding = -2,
	right_padding = -2,
	bottom_padding = -2,
	left_padding = -2,
	width = 36,
	height = 36,
	scalable = true,
}

default_gui.chronokit_flow_style =
{
	type = "horizontal_flow_style",
	parent = "horizontal_flow",
	top_padding = 5,
	bottom_padding = 5,
	left_padding = 5,
	right_padding = 5,

	horizontal_spacing = 0,
	vertical_spacing = 0,
	max_on_row = 0,
	resize_row_to_width = true,

	graphical_set = { type = "none" },
}

default_gui.chronokit_button_style =
{
	type = "button_style",
	parent = "button",
	font = "chronokit_font_bold",
	align = "center",
	top_padding = 1,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	height = 36,
	minimal_width = 36,
	scalable = false,
	left_click_sound = "__core__/sound/gui-click.ogg",
}
