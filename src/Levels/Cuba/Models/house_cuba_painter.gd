@tool
extends Node3D
@export var wall_color: Color=Color(1, 1, 1)
@export var door_color: Color=Color(1, 1, 1)
@export var getShitDone : bool = false:
	set(_value):
		get_shit_done()
		getShitDone = false
		
var materials: Array
var materials_b: Array

func get_shit_done():
#	if not Engine.is_editor_hint():
#		return
	for material in materials:
		material.albedo_color = wall_color
	for material in materials_b:
		material.albedo_color = door_color

func _ready():
	for mesh in self.find_children("Wall_*"):
		materials.append(mesh.get_surface_override_material(0))
	for mesh in self.find_children("Door_*"):
		materials.append(mesh.get_surface_override_material(0))
	get_shit_done()
