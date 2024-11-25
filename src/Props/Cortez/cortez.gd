extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var col = randi_range(0,7)
	$Cortez.get_surface_override_material(0).set_shader_parameter("Color",col)
