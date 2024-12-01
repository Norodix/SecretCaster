extends Node3D

func _ready() -> void:
	$Camera3D.current = false


# this is the hackiest ugliest shittyest code ever written
# im proud
func cutscene(): 
	$Camera3D.current = true
	get_tree().root.find_child("Player", true, false).process_mode=Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.play("End")
	await $AnimationPlayer.animation_finished
	var sar = get_tree().root.find_child("sarcophagus", true, false)
	var anim : AnimationPlayer = sar.find_child("AnimationPlayer")
	anim.play_backwards("lid_open")
	await anim.animation_finished
	get_tree().quit()
	
