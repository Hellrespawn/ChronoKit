# Factorio Mod Conventions

Project-specific conventions observed in this codebase that go beyond what the Factorio modding API itself requires. Nothing here is enforced by the game or the `factoriomod-debug` toolchain — it's house style, kept separate from `CLAUDE.md` so it can be copied into other mod repos as a starting point.

## Module structure

- One module per concern under `src/`, each following `local M = {}` ... `return M`, with dependencies pulled in via `require("src.xxx")` at the top of the file.
- `control.lua` is the **only** file that calls `script.on_event`. It wires Factorio events to handler functions exported by `src/*.lua` modules; the modules contain the actual logic. This keeps "what triggers this" (control.lua) separate from "what happens" (src/).
- `data.lua` (prototype stage) and `settings.lua` (settings stage) stay free of runtime logic — they only `data:extend(...)`.

## Constants

- A single `src/constants.lua` holds every shared string: setting names, GUI tag/action names, enum values, color tables. Other modules reference `constants.SOMETHING` rather than repeating string literals. If two files need the same string, it belongs in `constants.lua`, not duplicated.
- Enum-like values (e.g. a cycle of states) are declared alongside an explicit order table (e.g. `DAMAGE_ACTION_ORDER`) so cycling/iteration logic can walk the table instead of hardcoding `if/elseif` chains.

## State ownership

- All persistent state lives in Factorio's `storage` table — never in module-local variables — because `storage` is what survives save/load and mod updates; module locals are re-evaluated on load and would silently reset.
- Every module that owns part of `storage`'s shape provides an explicit init/rebuild function (e.g. `init_storage()`), called from both `on_init` and `on_configuration_changed`, so schema changes and mod-setting changes have one clear re-initialization path.

## GUI modules

- GUI modules are pure renderers: a `create_gui(player)` / `update_gui(player)` pair that reads `storage` and live game state and writes to GUI elements, but never mutates game state itself. State-mutating logic lives in the handler modules; callers invoke `update_gui`/`update_guis` explicitly after a mutation.
- Every clickable GUI element gets a `tags = { mod = <mod_tag>, action = <action_name> }` table. `on_gui_click` in `control.lua` checks `tags.mod` up front (to ignore clicks from other mods' GUIs sharing the same parent), then dispatches through a single table keyed by `action_name` instead of a chain of per-element `if event.element.name == ...` checks.
- Admin-gated actions check `player.admin` before dispatch and print a localized "admin only" message on failure rather than silently ignoring the click.

## Event handlers

- In handlers for unfiltered, high-frequency events (e.g. `on_entity_damaged`, which fires for every damaged entity in the game), order guard clauses from cheapest to most expensive: numeric/table-lookup checks first, field access on the event payload (`event.entity`, `event.entity.force`) last. This avoids touching entity/force fields on the hot path when a cheap check would have bailed out anyway.

## Localization

- All player-visible strings (chat messages, tooltips, captions with meaning) are declared in `locale/<lang>/<lang>.cfg` and referenced from Lua as LocalisedString tables (`{ "mod-messages.xxx" }`, `{ "mod-tooltips.xxx", param }`), never as hardcoded Lua string literals. Pure formatting (e.g. `"x%1.1f"` for a speed multiplier) is the one exception — it's numeric display, not language.
- Factorio caps LocalisedString concatenation at 20 parameters per nesting level. For any list whose length depends on user config (not a fixed small count), build it with a recursive helper that nests overflow into a continuation slot every 19 entries, rather than assuming the list stays short.

## Naming

- `snake_case` for functions and local variables.
- `UPPER_SNAKE_CASE` for constants and enum-like values (including string constants used as identifiers/keys, not just numbers).
- GUI element name constants and the `action`/`mod` tag strings are declared once near the top of the owning module, not inlined at each `.add({...})` call.

## Voice for mod-portal copy

Modeled on well-regarded mod-portal listings (Long Reach, Rate Calculator, Even Distribution, Text Plates, Editor Extensions) — what they have in common once you strip the outliers that are really project logs, not listings.

- Open with the verb, not a preamble. "Adds a hotkey to pin unconnected undergrounds" beats "This mod adds a hotkey to pin unconnected undergrounds" — cut "This mod"/"This adds" whenever the sentence still works without it.
- Describe the mechanic, not its value. Say what the mod does in concrete, literal terms (scans, drops, calculates, reaches) and let the reader judge whether that's useful. Skip adjectives that assert quality instead of describing behavior ("powerful", "essential", "amazing", "seamless").
- State exact scope, including what it doesn't do, as a flat declarative sentence — e.g. "Doesn't work for mining." — not an apology or a caveat buried in a FAQ. Omitting a real limitation reads as more misleading than stating it bluntly.
- Address the player directly in second person for interaction steps ("You can reach whatever you can see", "press Shift+C"), reserving third person for describing what the mod itself does.
- Give controls as literal key combinations, either inline in brackets (`` [U] ``) or in the `| Button | Action |` table this repo already uses — never paraphrased ("the pin key", "your configured hotkey").
- Dry, incidental humor is fine (a parenthetical aside, one self-aware remark) but only after the functional sentence has already landed, never as a substitute for it, and never sales-pitch enthusiasm (exclamation points, "you'll love").
- No filler sign-off sections in `DESCRIPTION.md` — no "thanks for reading", no changelog-in-the-description, no begging for endorsements/ratings. That belongs in `README.md`'s repo-facing sections or `changelog.txt`, not the portal blurb.

## README.md and DESCRIPTION.md

- Two separate files, not one shared between contexts: `DESCRIPTION.md` is the mod-portal-facing listing copy (what a player sees before installing); `README.md` is the GitHub-facing doc (what a contributor or curious user sees in the repo). They overlap in content but are not identical, and `DESCRIPTION.md` is never just an include/symlink of part of `README.md`.
- `DESCRIPTION.md` stays terse: one dense opening paragraph explaining what the mod does and its core mechanic, followed by a single condensed `## Controls` table. No `## Settings` section, no secondary-feature prose, no badges or repo links — the mod portal already provides those.
- `README.md` is the fuller version: title, one-line tagline, then the same `## Controls` table (allowed to use fuller phrasing/line breaks than the DESCRIPTION version), plus any additional sections needed for secondary mechanics, and a `## Settings` table listing each setting's name, default, and allowed values/options.
- Control mappings are always presented as a `| Button | Action |` table, not prose — this is the one section duplicated (in trimmed form) between the two files, so keep both tables in sync by hand whenever a control changes; don't treat one as generated from the other.
- Settings tables use the columns `| Setting | Default | Options |` and list the setting's display name (not its internal `constants.SETTING_*` string), matching what the in-game settings menu shows.

## Packaging & release

- A packaging script (`package.ps1` here) reads `name`/`version` from `info.json`, stages an explicit allow-list of files/dirs (not a blanket copy of the repo), and zips to `dist/<name>_<version>.zip`. Keeping the include-list explicit prevents dev-only files (`.vscode/`, this doc, etc.) from ending up in a shipped release.
- Bump `info.json`'s `version` and add a `changelog.txt` entry before running the packaging script for a release — the zip filename itself is derived from `info.json`, so an unbumped version silently overwrites the previous release's artifact.
