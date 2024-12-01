extends StaticBody3D

var has_played = false

func damage(_amount, type):
	if has_played:
		print("Control panel already triggered")
		return
	if type == "shock":
		# try to find parent node and start its open animation
		var parent = get_parent_node_3d()
		if not parent:
			print("Not valid parent")
			return
		var anim = parent.find_child("AnimationPlayer")
		if not anim:
			print("Anim player not found")
			return
		if not anim is AnimationPlayer:
			print("Not an animation player")
			return
		if not anim.is_playing():
			print("Trigger animation")
			has_played = true
			anim.play("Open")
		else:
			print("Anim already playing")
	else:
		print("Invalid damage type")
