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

signal spell_used(type : int)
signal defeat # signals to all relevant components the end of the game
