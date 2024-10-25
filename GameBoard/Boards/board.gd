extends Node3D

@onready var solar_systems: Node3D = $SolarSystems
@onready var player: MeshInstance3D = $Player


func _ready() -> void:
	for source_system: SolarSystem in solar_systems.get_children():
		for dest_system: SolarSystem in solar_systems.get_children():
			if source_system == dest_system:
				continue
			
			var distance = source_system.global_position.distance_to(dest_system.global_position)
			
			if distance < source_system.orbit_radius + dest_system.orbit_radius + 1:
				#var closest_dest_sector: Sector = null
				
				for source_sector: Sector in source_system.sectors.get_children():
					for dest_sector: Sector in dest_system.sectors.get_children():
						pass
						# TODO
