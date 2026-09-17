class_name Upgrades

const OFFER_SIZE := 3
const POOL := [
	{"id": &"faster_sweep", "name": "Faster Sweep", "description": "The beam turns faster."},
	{"id": &"wider_beam", "name": "Wider Beam", "description": "The beam's cone gets wider."},
	{"id": &"second_beam", "name": "Second Beam", "description": "A second beam sweeps opposite the first."},
	{"id": &"movement_speed", "name": "Movement Speed", "description": "You move faster."},
	{"id": &"shield", "name": "Shield", "description": "Absorbs one hit, then recharges."},
]


static func draw_offer() -> Array:
	var pool := POOL.duplicate()
	pool.shuffle()
	return pool.slice(0, OFFER_SIZE)
