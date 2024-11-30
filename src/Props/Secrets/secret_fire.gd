extends secret


# TODO generate pattern to texture and compute distance texture from it
# That way it can actually show the text in the burn pattern
func _ready() -> void:
	await get_tree().process_frame
	var pattern = super.get_action_array()
	$Label3D.text = ""
	for text in pattern:
		var t = super.get_display_name(text)
		$Label3D.text += (t + "\n")
