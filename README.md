# ChronoKit

Control game speed in Factorio while playing.

## Controls

All controls require administrator privileges. The shortcut bar button toggles ChronoKit on and off.

| Button | Action |
|--------|--------|
| ⏸ / ▶ | Toggle pause. While paused, restores the previous speed. |
| `<` | Decrease the speed. While paused, unpauses at ×1. |
| `>` | Increase the speed. While paused, unpauses at ×1. |
| `x1.0` / `xN.N` / `/N.N` | At ×1 or paused: restore saved speed. While fast-forwarding: reset to ×1. |

Speed is shown as `xN.N` (above normal, red), `/N.N` (below normal, green), or `x1.0` (normal, white). While paused it shows `x0.0`. Hovering the speed button shows the full speed table.

## Damage protection

When a player-force entity takes damage while the game is running above normal speed, ChronoKit automatically reacts. The reaction is configurable:

- **Reset speed** (default) — speed resets to ×1 and a GPS link is printed to chat.
- **Pause game** — the game pauses and a GPS link is printed to chat.

## Settings

| Setting | Default | Options |
|---------|---------|---------|
| Maximum speed multiplier | 64× | 2, 4, 8, 16, 32, 64, 128 |
| Minimum speed | 1/8 | 1/2, 1/4, 1/8 |
| Action on damage while fast-forwarding | Reset speed | Reset speed, Pause game |
| Starting factor | 1.5 | Any value > 1 |
| Step increment | 0.25 | Any value ≥ 0 |

The speed table is built from the minimum speed up to the maximum, starting at ×1 and multiplying/dividing by the starting factor (which increases by the step increment at each step).
