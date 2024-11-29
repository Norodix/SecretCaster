extends StaticBody3D


@onready var lights = [
	$"../OmniLight3D",
	$"../OmniLight3D2",
	$"../OmniLight3D3",
	$"../OmniLight3D4",
]


func damage(_amount, type):
	for light in lights:
		if type == "shock":
			light.light_energy = 5


func _process(delta: float) -> void:
	for light in lights:
		light.light_energy = lerp(light.light_energy, 0.0, 0.05)
