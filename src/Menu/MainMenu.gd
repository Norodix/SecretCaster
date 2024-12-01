extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Utils.clear_existing()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Cuba/cuba.tscn")
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	var scene = load("res://Menu/Settings.tscn")
	self.add_child(scene.instantiate())
	pass # Replace with function body.
