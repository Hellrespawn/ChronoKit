# ChronoKit

Control game speed in Factorio while playing.

## Controls

All controls require administrator privileges.

| Button | Action |
|--------|--------|
| ⏸ / ▶ | Toggle pause |
| `<` | Halve game speed |
| `>` | Double game speed |
| `x1` / `xN` / `/N` | At ×1 or paused: restore saved speed. While fast-forwarding: reset to ×1 |

Speed is shown as `xN` (above normal, red), `/N` (below normal, green), or `x1` (normal, white). While paused it shows `x0`.

## Damage protection

When a player-force entity takes damage while the game is running above normal speed, ChronoKit automatically reacts. The reaction is configurable:

- **Reset speed** (default) — speed resets to ×1 and a GPS link is printed to chat.
- **Pause game** — the game pauses and a GPS link is printed to chat.

## Settings

| Setting | Default | Options |
|---------|---------|---------|
| Maximum speed multiplier | 64 | 2, 4, 8, 16, 32, 64, 128 |
| Action on damage while fast-forwarding | Reset speed | Reset speed, Pause game |

## TODO

- No toggle color isn't noticeable anymore with new toolbar design.
