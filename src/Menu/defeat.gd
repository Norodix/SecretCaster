extends Control


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://Menu/MainMenu.tscn")
	pass # Replace with function body.
