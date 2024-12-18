extends Node3D
class_name secret

## This spell name should match the node name of the player node
@export var spell_name : String

var display_text = {
	"forwards"    = "Step Forwards",
	"backwards"   = "Step Backwards",
	"left"        = "Step Left",
	"right"       = "Step Right",
	"jump"        = "Jump",
	"crouch"      = "Crouch",
	"use_spell"   = "Use spell or shoot",
	"attack_mode" = "Swap weapon / magic",
	"reload"      = "Reload",
}

func get_action_array(s = spell_name) -> Array:
	var ret = []
	var player = get_tree().root.find_child("Player", true, false)
	if not player:
		return ret
	var spell = player.find_child(s, true, false)
	if not spell:
		return ret
	if not "pattern" in spell:
		return ret
	return spell.pattern

func get_display_name(action : String):
	if display_text.has(action):
		return display_text[action]
	else:
		return action
