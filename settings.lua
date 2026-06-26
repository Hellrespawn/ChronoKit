local function assert_fraction(s)
    local num, den = s:match("^(%d+)/(%d+)$")
    assert(num and den and tonumber(den) ~= 0, "Invalid fraction: " .. s)
end

local min_speed_values = {"1/2", "1/4", "1/8"}
for _, v in ipairs(min_speed_values) do assert_fraction(v) end

data:extend({
    {
        type          = "int-setting",
        name          = "chronokit-maximum-speed",
        setting_type  = "runtime-global",
        default_value = 64,
        allowed_values = {2, 4, 8, 16, 32, 64, 128},
    },
    {
        type          = "string-setting",
        name          = "chronokit-minimum-speed",
        setting_type  = "runtime-global",
        default_value = "1/8",
        allowed_values = min_speed_values,
    },
    {
        type          = "string-setting",
        name          = "chronokit-damage-action",
        setting_type  = "runtime-global",
        default_value = "Reset speed",
        allowed_values = {"Reset speed", "Pause game"},
    },
    {
        type          = "double-setting",
        name          = "chronokit-starting-factor",
        setting_type  = "runtime-global",
        default_value = 1.5,
        minimum_value = 1.001,
    },
    {
        type          = "double-setting",
        name          = "chronokit-step-increment",
        setting_type  = "runtime-global",
        default_value = 0.25,
        minimum_value = 0,
    },
})
