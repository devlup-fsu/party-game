extends Node3D

@export var continue_movement_texture: Texture
@export var alternative_movement_texture: Texture

@onready var solar_systems: Node3D = $SolarSystems
@onready var camera: BoardCamera = $Camera

# TODO: Type as Dictionary[Controls.Player, BoardPlayer]
var players: Dictionary = {}
var current_player: BoardPlayer


func _ready() -> void:
	for player in $Players.get_children():
		if player is BoardPlayer:
			players[player.player] = player
			player.choosing_next_sector.connect(_on_player_choosing_next_sector)
	
	assert(players.keys().size() == 4)
	
	_next_player()
	
	_link_solar_systems()


func _link_solar_systems():
	for src_system: SolarSystem in solar_systems.get_children():
		for dst_system: SolarSystem in solar_systems.get_children():
			if src_system == dst_system:
				continue
			
			var distance = src_system.global_position.distance_to(dst_system.global_position)
			
			if distance < src_system.orbit_radius + dst_system.orbit_radius + 10:
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


func _next_player() -> void:
	if current_player == null:
		current_player = players[Controls.Player.ONE]
	else:
		var next_player = current_player.player + 1
		if next_player == Controls.Player.size():
			next_player = Controls.Player.ONE
		current_player = players[next_player]
	
	camera.target = current_player
	current_player.take_control()
	current_player.finished_turn.connect(_next_player)


func _on_player_finished_turn() -> void:
	var next_player = current_player.player + 1
	if next_player == Controls.Player.size():
		next_player = Controls.Player.ONE
	
	current_player = players[next_player]
	camera.target = current_player


func _on_player_choosing_next_sector(player: BoardPlayer, current_sector: Sector) -> void:
	var continue_sprite: Sprite3D = Sprite3D.new()
	continue_sprite.texture = continue_movement_texture
	continue_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	continue_sprite.pixel_size = 0.025
	current_sector.next[0].add_child(continue_sprite)
	
	var alternative_sprite: Sprite3D = Sprite3D.new()
	alternative_sprite.texture = alternative_movement_texture
	alternative_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	alternative_sprite.pixel_size = 0.025
	current_sector.next[1].add_child(alternative_sprite)
	
	await player.chose_next_sector
	
	continue_sprite.queue_free()
	alternative_sprite.queue_free()
