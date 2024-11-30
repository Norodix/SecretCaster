extends secret

func _ready() -> void:
	await get_tree().process_frame
	var pattern = super.get_action_array()
	$Label3D.text = ""
	for text in pattern:
		var t = super.get_display_name(text)
		$Label3D.text += (t + "\n")
