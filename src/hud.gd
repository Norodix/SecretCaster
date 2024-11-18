extends CanvasLayer

enum ATTACK_MODE {
	PISTOL,
	MAGIC,
	MAX, # must be last and unused
}

func select(spell : Node):
	# Select selections
	print("selecting ", spell)
	for child in find_children("Frame_*_Tex"):
		child.visible = false
	if "select_name" in spell:
		var select_node = find_child(spell.select_name)
		if select_node:
			select_node.visible = true
	# Feedback selection
	for child in find_children("*_Feedback"):
		child.visible = false
	if "feedback_name" in spell:
		var feedback_node = find_child(spell.feedback_name)
		if feedback_node:
			feedback_node.visible = true
			$Control/Feedback_fade.play("Fade")

func set_active_mode(mode):
	for child in find_children("Selected_Tex"):
		child.visible = false
	if mode == ATTACK_MODE.PISTOL:
		$Control/Spell_Frame_R/Selected_Tex.visible = true
	if mode == ATTACK_MODE.MAGIC:
		$Control/Spell_Frame_L/Selected_Tex.visible = true

func damage():
	$Control/Damage_fade.seek(0, true)
	$Control/Damage_fade.play("Fade")
