extends secret


# TODO generate pattern to texture and compute distance texture from it
# That way it can actually show the text in the burn pattern
func _ready() -> void:
	var pattern = super.get_action_array()
	$Label3D.text = ""
	for text in pattern:
		$Label3D.text += (text + "\n")
