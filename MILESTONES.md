# Milestones

One slice per session. One commit per slice. Every slice ends with something
runnable and playable. Do not start the next slice until the current one is
committed.

---

## 0. Project setup — do this yourself

Not an AI task. You want to know the ground truth of your own project settings.

- [ ] New Godot project, git repo initialised, `.gitignore` for Godot
- [ ] `DESIGN.md`, `CLAUDE.md`, `MILESTONES.md`, `WORKFLOW-NOTES.md` committed
- [ ] Exact Godot version filled into `CLAUDE.md`
- [ ] Display: viewport 1280x720, stretch mode `canvas_items`, aspect `keep`
- [ ] Input map: `move_left`, `move_right`, `move_up`, `move_down`
      (WASD + arrow keys both bound)
- [ ] Collision layer names set: 1 `player`, 2 `enemy`, 3 `walls`
- [ ] `main.tscn` created with a `Node2D` root and a near-black background,
      set as the main scene
- [ ] Project runs and shows a black window

**Acceptance:** the project opens, runs, and shows an empty dark screen.

---

## 1. Player moves

- [ ] `player.tscn`: `CharacterBody2D` root, white `ColorRect` 24x24 centred,
      `CollisionShape2D`
- [ ] 8-way movement with acceleration and friction, `@export` speed values
- [ ] Player clamped inside the screen bounds
- [ ] Instanced in `main.tscn`

**Acceptance:** you can move a white square around a dark screen and it can't
leave the screen. Movement feels like it has weight, not like a snap.

---

## 2. The beam sweeps

- [ ] `beam.gd` attached to a child node of the player
- [ ] `beam_angle` advances at an `@export` sweep speed in `_physics_process`
- [ ] Draws a translucent yellow wedge using `_draw()` or a `Polygon2D`
- [ ] `@export` beam range and half-width, visibly correct when changed
- [ ] No damage, no enemies yet

**Acceptance:** a wedge of light rotates smoothly around the player and follows
the player as they move. Changing the exported width and range in the inspector
visibly changes the wedge.

---

## 3. The beam kills something

- [ ] `enemy_walker.tscn`: `CharacterBody2D`, dark red 20x20 `ColorRect`
- [ ] `health` with `take_damage(amount)`, `queue_free()` at zero
- [ ] Beam hit detection by angle + distance math, as specified in `DESIGN.md`
- [ ] Per-enemy hit cooldown so one pass isn't dozens of hits
- [ ] A few enemies placed by hand in `main.tscn`, stationary

**Acceptance:** stationary red squares die when swept, take multiple passes to
kill, and squares outside the beam range survive. This slice defines your damage
interface — review it carefully.

---

## 4. The enemies come for you

- [ ] Walker moves toward the player at an `@export` speed
- [ ] Still placed by hand, no spawner yet

**Acceptance:** red squares chase you and you can kill them by sweeping. First
real playtest: is there tension between running away and lining up the sweep?
If not, stop and fix the design before adding anything else.

---

## 5. You can die

- [ ] Player health, contact damage from enemies
- [ ] Brief invulnerability window after a hit, visibly flashing
- [ ] Death → game over screen → restart
- [ ] Minimal HUD showing health

**Acceptance:** a full mini-game exists. You can lose and press a key to retry.

---

## 6. Waves

- [ ] `wave_spawner.gd` spawns enemies from random screen-edge positions
- [ ] Wave definitions in one const table
- [ ] Wave ends when all enemies are dead, short pause, next wave begins
- [ ] HUD shows the wave number

**Acceptance:** waves escalate in count and speed, and you can survive several
before dying.

---

## 7. Upgrade screen

- [ ] Between waves, game pauses and offers 3 upgrades drawn from a pool
- [ ] Keyboard selection, resume on pick
- [ ] Upgrades are data, not hardcoded UI branches

**Acceptance:** picking an upgrade closes the screen and starts the next wave.
The upgrades do not need to do anything yet.

---

## 8. Upgrades do things

- [ ] Faster sweep, wider beam, second beam, movement speed, shield
- [ ] Second beam is an angle offset, not a duplicated system
- [ ] Shield absorbs one hit, recharges after N seconds, visibly indicated
- [ ] Smallest possible modifier mechanism — no upgrade framework

**Acceptance:** each upgrade is noticeably different to play with. If two feel
identical, the damage model is wrong — re-read the combat model in `DESIGN.md`.

---

## 9. Full run

- [ ] 10 waves with a real escalation curve, then a boss
- [ ] Boss: high HP, one distinct behaviour, no new systems
- [ ] Victory screen, distinct from the death screen

**Acceptance:** a complete run takes roughly 8 minutes and can be won.

---

## 10. Score

- [ ] Score accumulates during a run, shown in the HUD
- [ ] Best score saved to `user://` and shown on the title and game over screens

**Acceptance:** best score survives closing and reopening the game.

---

## 11. Juice, then art

- [ ] Hit flash, death effect, screenshake, beam glow
- [ ] Sound: sweep hum, hit, death, upgrade pick
- [ ] Only now: replace placeholder rectangles with art

**Acceptance:** it looks and sounds like a game rather than a prototype.
