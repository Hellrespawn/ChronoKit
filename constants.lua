local M = {}

M.colors = {
    white    = {r = 1,   g = 1,   b = 1},
    green    = {r = 0,   g = 1,   b = 0},
    lightred = {r = 1,   g = 0.5, b = 0.5},
    gray     = {r = 0.85, g = 0.85, b = 0.85},
}

M.SETTING_MAX_SPEED      = "chronokit-maximum-speed"
M.SETTING_MIN_SPEED      = "chronokit-minimum-speed"
M.SETTING_DAMAGE_ACTION  = "chronokit-damage-action"
M.SETTING_START_FACTOR   = "chronokit-starting-factor"
M.SETTING_STEP_INCREMENT = "chronokit-step-increment"

return M
