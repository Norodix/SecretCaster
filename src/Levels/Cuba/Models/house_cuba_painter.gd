@tool
extends Node3D

@export_range(1,3,1) var firstStoreyCount: int = 1
@export var firstWallColor: Color=Color(1, 1, 1)
@export var firstDoorColor: Color=Color(1, 1, 1)
var firstConnector
@export_range(0,3,1) var secondStoreyCount: int = 1
@export var secondWallColor: Color=Color(1, 1, 1)
@export var secondDoorColor: Color=Color(1, 1, 1)
var secondConnector
@export_range(0,3,1) var thirdStoreyCount: int = 1
@export var thirdWallColor: Color=Color(1, 1, 1)
@export var thirdDoorColor: Color=Color(1, 1, 1)

@export var getShitDone : bool = false:
	set(_value):
		get_shit_done()
		getShitDone = false


func get_shit_done():
#	if not Engine.is_editor_hint():
#		return
	for child in self.get_children():
		for grandchild in child.get_children():
			grandchild.visible = true
	for child in self.find_children("CollisionShape3D*"):
		child.disabled = false
	
	var a = 0
	for child in $Row1.find_children("house_cuba_storey*"):
		child.visible = clamp(firstStoreyCount - a, 0, 1)
		child.find_child("CollisionShape3D*").disabled = 1 - clamp(firstStoreyCount - a, 0, 1)
		a += 1
	$Row1/house_cuba_railing.global_position = $Row1/house_cuba_ground.global_position + Vector3(0, (firstStoreyCount - 1) * 5, 0)
	
	a = 0
	if secondStoreyCount: 
		for child in $Row2.find_children("house_cuba_storey*"):
			child.visible = clamp(secondStoreyCount - a, 0, 1)
			child.find_child("CollisionShape3D*").disabled = 1 - clamp(secondStoreyCount - a, 0, 1)
			a += 1
		$Row2/house_cuba_railing.global_position = $Row2/house_cuba_ground.global_position + Vector3(0, (secondStoreyCount - 1) * 5, 0)
		
		if secondStoreyCount > firstStoreyCount:
			firstConnector = firstStoreyCount
		else:
			firstConnector = secondStoreyCount
		a = 0
		for child in $Row2.find_children("house_connector_storey*"):
			child.visible = clamp(firstConnector - a, 0, 1)
			child.find_child("CollisionShape3D*").disabled = 1 - clamp(firstConnector - a, 0, 1)
			a += 1
		$Row2/house_connector_railing.global_position = $Row2/house_connector_ground.global_position + Vector3(0, (firstConnector - 1) * 5, 0)
	else:
		for child in $Row2.get_children():
			child.visible = false
			child.find_child("CollisionShape3D*").disabled = true
		for child in $Row3.find_children("house_connector*"):
			child.visible = false
			child.find_child("CollisionShape3D*").disabled = true
	
	a = 0
	if thirdStoreyCount:
		for child in $Row3.find_children("house_cuba_storey*"):
			child.visible = clamp(thirdStoreyCount - a, 0, 1)
			child.find_child("CollisionShape3D*").disabled = 1 - clamp(thirdStoreyCount - a, 0, 1)
			a += 1
		$Row3/house_cuba_railing.global_position = $Row3/house_cuba_ground.global_position + Vector3(0, (thirdStoreyCount - 1) * 5, 0)
		
		if thirdStoreyCount > secondStoreyCount:
			secondConnector = secondStoreyCount
		else:
			secondConnector = thirdStoreyCount
		a = 0
		for child in $Row3.find_children("house_connector_storey*"):
			child.visible = clamp(secondConnector - a, 0, 1)
			child.find_child("CollisionShape3D*").disabled = 1 - clamp(secondConnector - a, 0, 1)
			a += 1
		$Row3/house_connector_railing.global_position = $Row3/house_connector_ground.global_position + Vector3(0, (secondConnector - 1) * 5, 0)
	else:
		for child in $Row3.get_children():
			child.visible = false
			child.find_child("CollisionShape3D*").disabled = true
	
	var houses: Array
	var connectors: Array
	var wMaterials: Array
	var dMaterials: Array
	var wConMaterials: Array
	var dConMaterials: Array
	var colors: Array
	colors.append(firstWallColor)
	colors.append(secondWallColor)
	colors.append(thirdWallColor)
	colors.append(firstDoorColor)
	colors.append(secondDoorColor)
	colors.append(thirdDoorColor)
	var stories: Array
	stories.append(0)
	stories.append(firstStoreyCount)
	stories.append(secondStoreyCount)
	stories.append(thirdStoreyCount)
	
	a = 0
	for row in self.get_children():
		for child in row.find_children("Storey"):
			houses.append(child)
		for child in row.find_children("Ground"):
			houses.append(child)
		for child in row.find_children("Railing_Roof"):
			houses.append(child)
		for child in houses:
			if child is MeshInstance3D:
				wMaterials.append(child.get_surface_override_material(0))
				dMaterials.append(child.get_surface_override_material(1))
		for material in wMaterials:
			material.albedo_color = colors[a]
		for material in dMaterials:
			material.albedo_color = colors[a + 3]
			
		for child in row.find_children("Storey_C*"):
			connectors.append(child)
		for child in row.find_children("Ground_C*"):
			connectors.append(child)
		for child in row.find_children("Railing_Roof_C*"):
			connectors.append(child)
		for child in connectors:
			if child is MeshInstance3D:
				wConMaterials.append(child.get_surface_override_material(0))
				dConMaterials.append(child.get_surface_override_material(1))
		if stories[a] > stories[a + 1]:
			for material in wConMaterials:
				material.albedo_color = colors[a]
			for material in dConMaterials:
				material.albedo_color = colors[a + 3]
		else:
			for material in wConMaterials:
				material.albedo_color = colors[a - 1]
			for material in dConMaterials:
				material.albedo_color = colors[a + 2]
		
		a += 1
		houses.clear()
		connectors.clear()
		wMaterials.clear()
		dMaterials.clear()
		wConMaterials.clear()
		dConMaterials.clear()

func _ready():
	get_shit_done()
