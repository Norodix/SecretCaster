extends Node3D

@onready var pistol = preload("res://Spells/Colt/ThrowingPistol.tscn")
# var pattern = ["right", "right", "right"]
@onready var pattern = Utils.generate_pattern(3)
var hand_name = "Colt-In-hand"
var sounds : Array[AudioStream]
const path = "res://Spells/Colt/Audio/"


func _ready() -> void:
	var files = DirAccess.get_files_at(path)
	for file in files:
		if file.match("Strain*.mp3"):
			sounds.append(load(path + file))


func use_spell(player: CharacterBody3D):
	var pistol_instance = pistol.instantiate()
	pistol_instance.start_basis = player.find_child("Camera3D").global_transform.basis
	get_tree().root.add_child(pistol_instance, true)
	pistol_instance.global_transform.origin = player.global_transform.origin + Vector3.UP * 0.2
	var i = randi_range(0, sounds.size() - 1)
	$AudioStreamPlayer3D.stream = sounds[i]
	$AudioStreamPlayer3D.play()
	SignalBus.spell_used.emit(SignalBus.SpellTypes.COLT)
