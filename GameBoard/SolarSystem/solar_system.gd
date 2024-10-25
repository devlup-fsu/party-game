@tool
class_name SolarSystem
extends Node3D

@onready var star_mesh: MeshInstance3D = $StarMesh
@onready var inner_orbit_mesh: MeshInstance3D = $InnerOrbitMesh
@onready var outer_orbit_mesh: MeshInstance3D = $OuterOrbitMesh
@onready var sector_line_meshes: Node3D = $SectorLineMeshes

@onready var sectors: Node3D = $Sectors
@onready var sector_scene: PackedScene = load("res://GameBoard/SolarSystem/sector.tscn")

@export_group("Star")
@export var star_color: Color:
	set(value):
		star_color = value
		_update_solar_system()
@export var star_radius: float = 1:
	set(value):
		star_radius = value
		_update_solar_system()

@export_group("Orbit")
@export var orbit_radius: float = 5:
	set(value):
		orbit_radius = value
		_update_solar_system()
@export var orbit_width: float = 2:
	set(value):
		orbit_width = value
		_update_solar_system()
@export var num_sectors: int = 12:
	set(value):
		num_sectors = value
		_update_solar_system()
@export_range(-180, 180, 0.001, "degrees") var radial_offset: float = 0:
	set(value):
		radial_offset = value
		_update_solar_system()
@export var clockwise: bool = true:
	set(value):
		clockwise = value
		_update_solar_system()


func _ready():
	_update_solar_system()


func _update_solar_system():
	if not is_node_ready() or not Engine.is_editor_hint():
		return
	
	if star_mesh and star_mesh.get_surface_override_material(0) is ShaderMaterial:
		star_mesh.get_surface_override_material(0).set("shader_parameter/Sun_Color", star_color)
	
	if star_mesh.mesh is SphereMesh:
		star_mesh.mesh.radius = star_radius
		star_mesh.mesh.height = star_radius * 2
	
	if inner_orbit_mesh.mesh is TorusMesh and outer_orbit_mesh.mesh is TorusMesh:
		inner_orbit_mesh.mesh.inner_radius = orbit_radius
		inner_orbit_mesh.mesh.outer_radius = orbit_radius + 0.1
		outer_orbit_mesh.mesh.inner_radius = orbit_radius + orbit_width
		outer_orbit_mesh.mesh.outer_radius = orbit_radius + orbit_width + 0.1
	
	if sector_line_meshes != null and sectors != null:
		while sector_line_meshes.get_child_count() != 0:
			var child = sector_line_meshes.get_child(0)
			sector_line_meshes.remove_child(child)
			child.queue_free()
		
		while sectors.get_child_count() != 0:
			var child = sectors.get_child(0)
			sectors.remove_child(child)
			child.queue_free()
		
		var pivot = Node3D.new()
		add_child(pivot)
		
		var prev_sector = null
		
		for i in range(num_sectors):
			var sector_line = MeshInstance3D.new()
			sector_line.name = "SectorLine%s" % i
			sector_line.rotation_degrees = Vector3(90, 0, 90)
			sector_line.position.x = -(orbit_radius + orbit_width / 2 + 0.05)
			
			sector_line.mesh = CylinderMesh.new()
			sector_line.mesh.height = orbit_width
			sector_line.mesh.top_radius = 0.05
			sector_line.mesh.bottom_radius = 0.05
			
			var sector: Node3D = sector_scene.instantiate()
			sector.name = "Sector%s" % i
			sector.index = i
			sector.position.x = -(orbit_radius + orbit_width / 2 + 0.05)
			
			pivot.add_child(sector_line)
			pivot.add_child(sector)
			pivot.rotation_degrees.y = ((i * 360 / float(num_sectors)) + radial_offset) * (-1 if clockwise else 1)
			var sector_line_global_transform = sector_line.global_transform
			pivot.remove_child(sector_line)
			pivot.rotation_degrees.y += (360 / float(num_sectors) / 2) * (-1 if clockwise else 1)
			var sector_global_transform = sector.global_transform
			pivot.remove_child(sector)
			pivot.rotation = Vector3()
			
			sector_line_meshes.add_child(sector_line)
			sector_line.owner = get_tree().edited_scene_root
			sector_line.global_transform = sector_line_global_transform
			
			sectors.add_child(sector)
			sector.owner = get_tree().edited_scene_root
			sector.global_transform = sector_global_transform
			
			if not clockwise:
				sector.rotation_degrees.y += 180
			
			if prev_sector != null:
				prev_sector.next.append(sector)
			
			prev_sector = sector
		
		prev_sector.next.append(sectors.get_child(0))
		
		pivot.queue_free()
