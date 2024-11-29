extends Control


func _on_button_pressed() -> void:
	self.queue_free()
	#get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		self.queue_free()
