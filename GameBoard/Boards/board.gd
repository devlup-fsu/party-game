extends Node3D

@onready var solar_systems: Node3D = $SolarSystems
@onready var player: MeshInstance3D = $Player


func _ready() -> void:
	_link_solar_systems()


func _link_solar_systems():
	for src_system: SolarSystem in solar_systems.get_children():
		for dst_system: SolarSystem in solar_systems.get_children():
			if src_system == dst_system:
				continue
			
			var distance = src_system.global_position.distance_to(dst_system.global_position)
			
			if distance < src_system.orbit_radius + dst_system.orbit_radius + 5:
				var closest_src_sector: Sector = null
				var closest_dst_sector: Sector = null
				var closest_distance = null
				
				for src_sector: Sector in src_system.sectors.get_children():
					for dst_sector: Sector in dst_system.sectors.get_children():
						# Skips dst_sectors behind src_sector.
						if ((src_sector.global_position) - (dst_sector.global_position)).dot(src_sector.basis.z) < 0:
							continue
						
						var sector_distance = src_sector.global_position.distance_to(dst_sector.global_position)
						if closest_distance == null or sector_distance < closest_distance:
							closest_src_sector = src_sector
							closest_dst_sector = dst_sector
							closest_distance = sector_distance
				
				closest_src_sector.next.append(closest_dst_sector)
				#print("(%s, %s)" %[closest_src_sector.index, closest_dst_sector.index])
