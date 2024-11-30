extends secret


func _ready() -> void:
	await get_tree().process_frame
	var pattern = super.get_action_array()
	$Label3D.text = ""
	for text in pattern:
		$Label3D.text += (text + "\n")
