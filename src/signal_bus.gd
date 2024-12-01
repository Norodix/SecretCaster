extends Node

enum SpellTypes {
	INVALID,
	COLT,
	FIREBALL,
	FIREBLAST,
	HIGHJUMP,
	LIGHTNING,
	SNOW,
	LIGHT,
	WIND
}

var nodenames = [
	"",
	"Colt",
	"FireballSpawner",
	"Fireblast",
	"Highjump",
	"LightningSpawner",
	"SnowSpanwer",
	"StickyLightSpawner",
	"WindSpell",
]

var displaynames = [
	"",
	"Colt",
	"Fireball",
	"Fireblast",
	"Highjump",
	"Lightning Strike",
	"Snow",
	"Light",
	"Wind",	
]

signal spell_used(type : int)
signal defeat # signals to all relevant components the end of the game
