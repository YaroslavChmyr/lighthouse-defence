# Lighthouse — Design Brief

## One sentence

You're the keeper of a lighthouse under siege. Things come out of the dark.
Your only weapon is the beam.

## Core loop

Top-down, single screen, no scrolling, no camera movement.

- The player moves freely with WASD/arrows.
- A beam of light sweeps continuously from the player's position at a constant
  angular speed. The player does **not** aim it and cannot fire it.
- The beam damages whatever it touches.
- The player's entire skill expression is **positioning**: moving so the sweep
  catches threats before they reach you.
- Enemies spawn from screen edges in escalating waves.
- Between waves, choose 1 of 3 upgrades.
- 10 waves, then a boss. A full run is ~8 minutes.
- Best score persists between runs.

## Why the design works

The tension is that moving to survive and moving to line up the sweep are
different goals. Retreating from an enemy often means turning your beam away
from it. If playtesting shows that tension isn't there, the game is broken and
no amount of content fixes it.

## Scope cap — NOT in v1

Explicitly out of scope. Do not build these, do not design for them, do not add
abstraction "so we can add them later":

- Saving/loading a run in progress (only the best score persists)
- More than one enemy behaviour type until wave logic works
- Meta-progression, unlocks, currency between runs
- Menus beyond: title → play → game over → retry
- Settings, audio sliders, key rebinding
- Multiple levels, level layouts, obstacles, terrain
- Art, animation, particles, sound (until milestone 11)

## Combat model — decided, do not re-litigate

**Beam hit detection is math, not physics.** No Area2D, no CollisionPolygon2D
for the beam. For each active enemy:

1. `to_enemy = enemy.global_position - player.global_position`
2. Reject if `to_enemy.length() > beam_range`
3. Reject if `abs(angle_difference(beam_angle, to_enemy.angle())) > beam_half_width`
4. Otherwise it's a hit.

Drawing the beam is entirely separate from this and must never be the source of
truth for hits.

**Damage uses a per-enemy hit cooldown, not damage-per-second.** When the beam
hits an enemy, apply damage once and start a per-enemy cooldown (~0.25s) during
which the beam cannot hit that enemy again.

This is deliberate. Under a DPS model, a faster sweep gives more passes but
shorter contact per pass, so total damage is unchanged and "faster sweep"
becomes a dead upgrade. The cooldown model makes each upgrade mean something
different:

| Upgrade        | What it actually changes                                  |
|----------------|-----------------------------------------------------------|
| Faster sweep   | More hits per second; shorter gap before a threat is caught |
| Wider beam     | Easier to catch fast movers; occasional double-hit per pass |
| Second beam    | A second sweep angle, offset 180°; halves your blind spots  |
| Movement speed | More positioning options; the least direct, most flexible   |
| Shield         | Absorbs one contact hit, recharges after N seconds          |

The cooldown must stay shorter than the sweep period, or faster sweep gets
capped and stops being an upgrade.

## Starting tuning values

Guesses, not gospel. Expect to change all of them during playtesting. Keep them
as `@export` so they can be tuned in the editor without a code change.

- Viewport: 1280x720, fixed, no scrolling
- Player speed: 220 px/s, with acceleration and friction (not instant snap)
- Beam sweep speed: 90 deg/s (a 4-second full rotation)
- Beam half-width: 12 degrees (24-degree cone)
- Beam range: 400 px
- Beam damage: 1 per hit
- Beam per-enemy hit cooldown: 0.25s
- Basic enemy: 3 HP, 60 px/s, walks straight at the player
- Player: 3 HP, 1s invulnerability after taking a hit
- Wave 1: 4 enemies. Escalate count and speed, not HP, for the first few waves.

## Art direction — deferred to milestone 11

Everything is untextured `ColorRect` / `Polygon2D` until the core loop is
proven fun. Placeholder palette:

- Player: white square
- Beam: soft yellow translucent wedge
- Basic enemy: dark red square
- Background: near-black
- Boss: larger dark red shape

Note for later: the beam rotates smoothly at arbitrary angles, which fights
with strict low-resolution pixel art (rotated pixel sprites shimmer). When art
happens, prefer clean vector-ish or higher-resolution shapes over 32x32 pixel
art.
