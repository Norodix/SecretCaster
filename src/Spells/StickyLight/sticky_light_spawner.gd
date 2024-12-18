extends Node3D

# var pattern = ["left", "left", "left"]
@onready var pattern = Utils.generate_pattern(8)
var cooldown = 500
@onready var resource = preload("res://Spells/StickyLight/sticky_light_ball.tscn")

var select_name = "Frame_StickyLight_Tex"
var feedback_name = "StickyLight_Feedback"
var hand_name = "StickyLight-In-hand"

func use_spell(player: CharacterBody3D):
	var instance = resource.instantiate()
	get_tree().root.add_child(instance, true)
	instance.global_transform.basis = player.find_child("Camera3D").global_transform.basis
	instance.global_transform.origin = player.global_transform.origin
	instance.velocity = instance.global_transform.basis * 20 * Vector3(0, 0.25, -1).normalized()
	SignalBus.spell_used.emit(SignalBus.SpellTypes.LIGHT)
