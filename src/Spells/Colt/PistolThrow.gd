extends Node3D

@onready var pistol = preload("res://Spells/Colt/ThrowingPistol.tscn")
var pattern = ["right", "right", "right"]

func use_spell(player: CharacterBody3D):
	var pistol_instance = pistol.instantiate()
	get_tree().root.add_child(pistol_instance, true)
	pistol_instance.global_transform.basis = player.find_child("Camera3D").global_transform.basis
	pistol_instance.global_transform.origin = player.global_transform.origin + Vector3.UP * 0.2
