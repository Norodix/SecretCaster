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

func clear_existing():
	existing_patterns = []

var existing_patterns = []

func concat_pattern(pattern : Array):
	var ret = ""
	for p in pattern:
		ret += p
	return ret


# Return true if there is a pattern that fully contains the other
func pattern_duplicate(concatted_pattern):
	if existing_patterns.is_empty():
		return false
	for p in existing_patterns:
		if concatted_pattern in p:
			return true
	return false

# generate a pattern with n number of elements
# This has a low chance to crash the game if it cannot find a completely unique pattern in 1k tries
func generate_pattern(n : int) -> Array:
	var pattern = []
	for i in n:
		var s = randi() % valid_actions.size()
		pattern.append(valid_actions[s])
	#if existing_patterns.has(concat_pattern(pattern)):
	if pattern_duplicate(concat_pattern(pattern)):
		# recursive call because pattern already exists somewhere else
		print("Recursive call needed because already esisting pattern found")
		print(pattern)
		pattern =  generate_pattern(n)
	# by this point it should be unique
	existing_patterns.append(concat_pattern(pattern))
	return pattern
