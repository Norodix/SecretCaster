extends Control

var pause = false : set = pause_logic


func _ready():
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		pause = not pause


func pause_logic(new_state):
	pause = new_state
	get_tree().paused = pause
	visible = pause
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pause else Input.MOUSE_MODE_CAPTURED


func _on_resume_pressed() -> void:
	pause = false
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	pause = false
	get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pause = false
	get_tree().quit()
	pass # Replace with function body.


func _on_options_pressed() -> void:
	var scene = load("res://Menu/Settings.tscn")
	self.add_child(scene.instantiate())
	pass # Replace with function body.
