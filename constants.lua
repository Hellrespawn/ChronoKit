local M                  = {}

M.colors                 = {
    white = { r = 1, g = 1, b = 1 },
    green = { r = 0, g = 1, b = 0 },
    red   = { r = 1, g = 0.5, b = 0.5 },
    gray  = { r = 0.85, g = 0.85, b = 0.85 },
}

M.MOD_NAME               = "ChronoKit"
M.MOD_TAG                = "chronokit"

M.ACTION_PLAY_PAUSE       = "play_pause"
M.ACTION_SLOWER          = "slower"
M.ACTION_FASTER          = "faster"
M.ACTION_SPEED           = "speed"

M.SETTING_MAX_SPEED      = "chronokit-maximum-speed"
M.SETTING_MIN_SPEED      = "chronokit-minimum-speed"
M.SETTING_DAMAGE_ACTION  = "chronokit-damage-action"
M.SETTING_START_FACTOR   = "chronokit-starting-factor"
M.SETTING_STEP_INCREMENT = "chronokit-step-increment"

M.DAMAGE_ACTION_RESET    = "Reset speed"
M.DAMAGE_ACTION_PAUSE    = "Pause game"

return M
