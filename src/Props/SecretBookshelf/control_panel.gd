extends StaticBody3D

var has_played = false

func damage(_amount, type):
	if has_played:
		return
	if type == "shock":
		# try to find parent node and start its open animation
		var parent = get_parent_node_3d()
		if not parent:
			return
		var anim = parent.find_child("AnimationPlayer")
		if not anim:
			return
		if not anim is AnimationPlayer:
			return
		if not anim.is_playing():
			has_played = true
			anim.play("Open")
