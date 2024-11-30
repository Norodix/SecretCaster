extends secret


func _ready() -> void:
	var pattern = super.get_action_array()
	$Label3D.text = ""
	for text in pattern:
		$Label3D.text += (text + "\n")
