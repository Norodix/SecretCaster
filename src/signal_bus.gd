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
