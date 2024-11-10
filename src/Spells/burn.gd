extends Area3D

var pattern = ["right", "forwards", "left", "left", "forwards", "right"]

const timeout_ms = 2000
var starttime = - timeout_ms * 1000

func use_spell(player: CharacterBody3D):
	var burnables = get_overlapping_bodies()
	$MeshInstance3D.visible = true
	starttime = Time.get_ticks_msec()
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()

func _process(delta):
	if Time.get_ticks_msec() > starttime + timeout_ms:
		$MeshInstance3D.visible = false
