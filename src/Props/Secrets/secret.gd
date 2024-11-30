extends Node3D
class_name secret

@export var spell_name : String

func get_action_array() -> Array:
	var ret = []
	var player = get_tree().root.find_child("Player", true, false)
	if not player:
		return ret
	var spell = player.find_child(spell_name, true, false)
	if not spell:
		return ret
	if not "pattern" in spell:
		return ret
	return spell.pattern
