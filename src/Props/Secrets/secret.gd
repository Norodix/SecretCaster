extends Node3D
class_name secret

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

func get_display_name(action : String):
	if display_text.has(action):
		return display_text[action]
	else:
		return action
