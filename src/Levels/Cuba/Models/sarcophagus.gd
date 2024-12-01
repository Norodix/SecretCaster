extends Node3D

func _ready() -> void:
	SignalBus.spell_used.connect(spell_used_callback)

var types_used = []
var wind_has_been_cast = false
var can_be_called = true
func spell_used_callback(type : int):
	if not can_be_called:
		return
	if type == SignalBus.SpellTypes.WIND:
		wind_has_been_cast = true
	if not wind_has_been_cast:
		return
	if not type in types_used:
		types_used.append(type)
	if types_used.size() >= 7:
		can_be_called = false
		$AnimationPlayer.play("lid_open")
		await $AnimationPlayer.animation_finished
		get_tree().root.find_child("Cutscene", true, false).cutscene()
