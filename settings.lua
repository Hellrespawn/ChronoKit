local constants = require("constants")

local function assert_fraction(s)
    local num, den = s:match("^(%d+)/(%d+)$")
    assert(num and den and tonumber(den) ~= 0, "Invalid fraction: " .. s)
end

local min_speed_values = { "1/2", "1/4", "1/8" }
for _, v in ipairs(min_speed_values) do assert_fraction(v) end

data:extend({
    {
        type           = "int-setting",
        name           = constants.SETTING_MAX_SPEED,
        setting_type   = "runtime-global",
        default_value  = 64,
        allowed_values = { 2, 4, 8, 16, 32, 64, 128 },
    },
    {
        type           = "string-setting",
        name           = constants.SETTING_MIN_SPEED,
        setting_type   = "runtime-global",
        default_value  = "1/8",
        allowed_values = min_speed_values,
    },
    {
        type           = "string-setting",
        name           = constants.SETTING_DAMAGE_ACTION,
        setting_type   = "runtime-global",
        default_value  = constants.DAMAGE_ACTION_RESET,
        allowed_values = { constants.DAMAGE_ACTION_RESET, constants.DAMAGE_ACTION_PAUSE },
    },
    {
        type          = "double-setting",
        name          = constants.SETTING_START_FACTOR,
        setting_type  = "runtime-global",
        default_value = 1.5,
        minimum_value = 1.001,
    },
    {
        type          = "double-setting",
        name          = constants.SETTING_STEP_INCREMENT,
        setting_type  = "runtime-global",
        default_value = 0.25,
        minimum_value = 0,
    },
})
