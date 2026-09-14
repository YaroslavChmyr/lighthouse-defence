# CLAUDE.md — Working agreement for this project

Read `DESIGN.md` before proposing anything. Read `MILESTONES.md` to see what
slice we're on. Do not build ahead of the current slice.

---

## Project facts

- **Engine: Godot `4.6.1`**
  Use only APIs that exist in this version. Godot 3 syntax is a recurring
  failure: `yield`, `KinematicBody2D`, `export var`, `onready var`, and
  `connect("signal", self, "method")` are all wrong here. If unsure whether a
  method or class exists in this version, say so rather than guessing.
- Language: GDScript only. No C#, no GDExtension.
- 2D only. Single fixed screen, 1280x720, no scrolling camera.
- Target: desktop, keyboard + no mouse aiming (the beam is not aimed).

## Folder layout

```
res://
  autoload/        game.gd — the single autoload
  entities/
    player/        player.tscn, player.gd
    enemies/       enemy_walker.tscn, enemy_walker.gd, ...
    beam/          beam.tscn, beam.gd
  systems/         wave_spawner.gd, upgrades.gd, save.gd
  ui/              hud.tscn, upgrade_screen.tscn, game_over.tscn
  main.tscn        the only scene that runs
  assets/          empty until milestone 11
```

Each entity keeps its `.tscn` and `.gd` in the same folder, same base name,
snake_case.

## Naming

- Files and folders: `snake_case`
- Classes and node names: `PascalCase`
- Variables, functions, signals: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`
- Private members: `_leading_underscore`
- Boolean names read as questions: `is_dead`, `can_be_hit`, not `dead_flag`

## Architecture rules

**Signals up, calls down.** A parent may call methods on its children. A child
must never reach up the tree. No `get_node("../../Thing")`, no
`get_parent().something`, no `get_tree().get_first_node_in_group(...)` used as a
backdoor to a parent.

**One autoload: `Game`.** It holds run state only — current wave, score, best
score, run active or not. Adding a second autoload requires asking first and
justifying it. Autoloads are where AI-assisted projects turn into mud.

**The beam is logic, not a collision shape.** Hit detection is the angle-and-
distance math described in `DESIGN.md`. The visual wedge is a separate concern
and is never queried for hits.

**Tunable numbers are `@export`, never literals in the middle of a function.**
If a number affects game feel, it is exported. Wave definitions live in one
const table in `wave_spawner.gd`.

**Do not abstract until the third use.** No base classes, no state machine
framework, no component system, no event bus, no interfaces until three
concrete cases exist and the duplication is real. Two enemies that both move
toward the player do not justify an inheritance hierarchy yet.

**Enemies are freed, not hidden.** Use `queue_free()`. Object pooling is
premature at this scale; do not introduce it.

## Collision layers

Set these once and use them consistently. Never pass raw layer bitmask ints in
code — set layers in the editor or via named constants.

| Layer | Name     | Used by                          |
|-------|----------|----------------------------------|
| 1     | player   | Player body                      |
| 2     | enemy    | Enemy bodies                     |
| 3     | walls    | Screen-edge bounds, if any       |

The beam occupies no layer — it isn't physics.

## Process rules

- Movement and physics in `_physics_process(delta)`.
- Beam rotation, hit checks, and timers in `_physics_process(delta)` too, so
  hit results are deterministic relative to movement.
- `_process(delta)` is for visuals and UI only.
- Never use `await get_tree().create_timer()` for gameplay-critical timing.
  Use accumulated `delta` or a `Timer` node so it's inspectable and pausable.

## How we work

1. **Plan before code.** For each slice, state: which files are created or
   modified, which nodes are added and to which scene, which signals are
   introduced, and the acceptance criteria. Wait for approval.
2. **Stay in scope.** Do not touch files outside the current slice. If
   something outside scope is broken, report it, don't fix it silently.
3. **Scripts via file writes. Scene structure via the MCP or by hand.**
   Do not hand-write or rewrite `.tscn` files as raw text — UIDs, sub-resource
   references, and node paths break silently that way.
4. **After implementing, run the project and read the debug output.** Iterate on
   runtime errors before handing back.
5. **Report honestly.** If something is untested, say it's untested. Never
   claim a bug is fixed without having run it.
6. **Explain on request without defensiveness.** If I can't explain a piece of
   code, it gets simplified or removed.

## Recurring mistakes to avoid

Append to this list as they come up (see `WORKFLOW-NOTES.md`).

- Emitting Godot 3 syntax.
- Inventing methods or properties that don't exist on a node type.
- Building a system for a feature that's in the scope cap.
- Adding an abstraction layer on the first or second use.
- Burying tunable values as literals inside functions.
