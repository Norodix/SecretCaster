extends Node

var valid_actions = [
	"forwards",
	"backwards",
	"left",
	"right",
	"jump",
	"crouch",
	"use_spell",
	"attack_mode",
	"reload",
]
# generate a pattern with n number of elements
func generate_pattern(n : int) -> Array:
	var pattern = []
	for i in n:
		var s = randi() % valid_actions.size()
		pattern.append(valid_actions[s])
	return pattern
