extends StaticBody3D

@onready var light = get_parent().find_child("OmniLight3D")


func damage(_amount, type):
	if type == "shock":
		light.light_energy = 100


func _process(delta: float) -> void:
	light.light_energy = lerp(light.light_energy, 5.0, 0.05)
