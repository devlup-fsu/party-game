@tool
extends Node3D

@onready var star_mesh: MeshInstance3D = $StarMesh
@onready var inner_orbit_mesh: MeshInstance3D = $InnerOrbitMesh
@onready var outer_orbit_mesh: MeshInstance3D = $OuterOrbitMesh
@onready var sector_meshes: Node3D = $SectorMeshes

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
@export var sectors: int = 12:
	set(value):
		sectors = value
		_update_solar_system()
@export_range(-180, 180, 0.001, "degrees") var radial_offset: float = 0:
	set(value):
		radial_offset = value
		_update_solar_system()


func _update_solar_system():
	if not Engine.is_editor_hint():
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
	
	if sector_meshes != null:
		while sector_meshes.get_child_count() != 0:
			var child = sector_meshes.get_child(0)
			sector_meshes.remove_child(child)
			child.queue_free()
		
		var pivot = Node3D.new()
		add_child(pivot)
		
		for i in range(sectors):
			var sector = MeshInstance3D.new()
			sector.name = "SectorLine%s" % i
			sector.rotation_degrees = Vector3(90, 0, 90)
			sector.position.x = -(orbit_radius + orbit_width / 2 + 0.05)
			
			sector.mesh = CylinderMesh.new()
			sector.mesh.height = orbit_width
			sector.mesh.top_radius = 0.05
			sector.mesh.bottom_radius = 0.05
			
			pivot.add_child(sector)
			pivot.rotation_degrees.y = (i * 360 / float(sectors)) + radial_offset
			var sector_global_transform = sector.global_transform
			pivot.remove_child(sector)
			pivot.rotation = Vector3()
			
			sector_meshes.add_child(sector)
			sector.owner = get_tree().edited_scene_root
			sector.global_transform = sector_global_transform
		
		pivot.queue_free()
