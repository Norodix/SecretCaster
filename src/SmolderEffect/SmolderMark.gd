extends Node3D

var burnt = false

func burn():
	if burnt:
		return
	burnt = true
	get_parent().find_child("AnimationPlayer").play("burn")
	
