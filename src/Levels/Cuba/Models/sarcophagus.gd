extends Node3D

func _ready() -> void:
	SignalBus.spell_used.connect(spell_used_callback)

var types_used = []
var wind_has_been_cast = false
func spell_used_callback(type : int):
	if type == SignalBus.SpellTypes.WIND:
		wind_has_been_cast = true
	if not wind_has_been_cast:
		return
	if not type in types_used:
		types_used.append(type)
	if types_used.size() >= 7:
		$AnimationPlayer.play("lid_open")
