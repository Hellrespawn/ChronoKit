data:extend(
	{
		{
			type = "int-setting",
			name = "chronokit-maximum-speed",
			setting_type = "runtime-global",
			default_value = 64,
			allowed_values = {2, 4, 8, 16, 32, 64, 128}
		},
		{
			type = "string-setting",
			name = "chronokit-damage-action",
			setting_type = "runtime-global",
			default_value = "Reset speed",
			allowed_values = {"Reset speed", "Pause game"}
		},
	}
)
