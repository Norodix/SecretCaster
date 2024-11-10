extends Node3D

var pattern = ["forwards", "right", "forwards", "left", "forwards"]
@onready var fireball_resource = preload("res://Spells/Fireball/Fireball.tscn")

func use_spell(player: CharacterBody3D):
	var fireball_instance = fireball_resource.instantiate()
	get_tree().root.add_child(fireball_instance, true)
	fireball_instance.global_transform.basis = player.find_child("Camera3D").global_transform.basis
	fireball_instance.global_transform.origin = player.global_transform.origin
