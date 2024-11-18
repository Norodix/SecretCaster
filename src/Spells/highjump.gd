extends Node3D

var pattern = ["forwards", "forwards", "forwards", "backwards", "forwards"]

var select_name = "Frame_Highjump_Tex"
var feedback_name = "Highjump_Feedback"

func use_spell(player: CharacterBody3D):
	player.velocity.y = 10
