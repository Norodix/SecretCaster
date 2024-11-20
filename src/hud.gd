extends CanvasLayer

enum ATTACK_MODE {
	PISTOL,
	MAGIC,
	MAX, # must be last and unused
}

@onready var magLabel = find_child("Magazine_Label")
@onready var slashLabel = find_child("Slash_Label")
@onready var ammoLabel = find_child("Ammo_Label")
@onready var hudAspect = find_child("16-9-aspect")
@onready var chAmmo = find_child("Crosshair_Ammo")
@onready var chSpell = find_child("Crosshair_SpellCD")


func _physics_process(delta: float) -> void:
	var bullets = self.get_parent().bullets
	var bullet_count = float(self.get_parent().bullet_count) + 1.0
	
	chAmmo.material.set_shader_parameter("fillLength", float(bullets / bullet_count))
	chSpell.material.set_shader_parameter("fillLength", 1.0)
	
	magLabel.text = str(bullets)
	ammoLabel.text = "∞"
	magLabel.theme.default_font_size = int(hudAspect.size.y / 10.0)
	slashLabel.theme.default_font_size = int(hudAspect.size.y / 16.2)
	ammoLabel.theme.default_font_size = int(hudAspect.size.y / 26.0)

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
	for child in find_children("*_Selected_Tex"):
		child.visible = false
	if mode == ATTACK_MODE.PISTOL:
		find_child("Pistol_Selected_Tex").visible = true
	if mode == ATTACK_MODE.MAGIC:
		find_child("Spell_Selected_Tex").visible = true

func damage():
	$Control/Damage_fade.seek(0, true)
	$Control/Damage_fade.play("Fade")
