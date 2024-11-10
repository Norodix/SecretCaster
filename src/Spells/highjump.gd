extends Node3D

var pattern = ["forwards", "forwards", "forwards", "backwards", "forwards"]

func use_spell(player: CharacterBody3D):
	player.velocity.y = 10
