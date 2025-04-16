class_name GameBoard
extends Node3D

signal next_minigame_command(full_command: String)

@export var continue_movement_texture: Texture
@export var alternative_movement_texture: Texture

@onready var solar_systems: Node3D = $SolarSystems
@onready var camera: BoardCamera = $Camera

# TODO: Type as Dictionary[Controls.Player, BoardPlayer]
var _players: Dictionary = {}
var _current_player: BoardPlayer
var _minigames_to_play: Array[Minigame] = []
var _last_minigame: Minigame = null


func _ready() -> void:
	for player in $Players.get_children():
		if player is BoardPlayer:
			_players[player.player] = player
			player.choosing_next_sector.connect(_on_player_choosing_next_sector)
	
	assert(_players.keys().size() == 4)
	
	_switch_to_next_player()
	
	_link_solar_systems()
	
	Console.replace_command("next_minigame", next_minigame_command)
	next_minigame_command.connect(_on_next_minigame_command)


func returned_to() -> void:
	camera.teleport_to_player(_current_player)


func _on_next_minigame_command(_full_command: String) -> void:
	_load_random_minigame()


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


func _load_random_minigame() -> void:
	if _minigames_to_play.is_empty():
		_minigames_to_play = SceneManager.get_published_minigames()
		_minigames_to_play.erase(_last_minigame)
	
	_last_minigame = _minigames_to_play.pick_random()
	_minigames_to_play.erase(_last_minigame)
	SceneManager.load_minigame(_last_minigame, true)


func _switch_to_next_player() -> void:
	if _current_player == null:
		_current_player = _players[Controls.Player.ONE]
	else:
		var next_player = _current_player.player + 1
		
		# Wrap player over to Player.ONE. Play minigame. Teleport camera
		if next_player == Controls.Player.size():
			next_player = Controls.Player.ONE
			
			_load_random_minigame()
			
		_current_player = _players[next_player]
	
	camera.target = _current_player
	_current_player.take_control()
	if not _current_player.finished_turn.is_connected(_switch_to_next_player):
		_current_player.finished_turn.connect(_switch_to_next_player)


func _on_player_finished_turn() -> void:
	var next_player = _current_player.player + 1
	if next_player == Controls.Player.size():
		next_player = Controls.Player.ONE
	
	_current_player = _players[next_player]
	camera.target = _current_player


func _on_player_choosing_next_sector(player: BoardPlayer, current_sector: Sector) -> void:	
	var continue_sprite: Sprite3D = Sprite3D.new()
	continue_sprite.texture = continue_movement_texture
	continue_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	continue_sprite.pixel_size = 0.025
	continue_sprite.position.y += 2.5
	current_sector.next[0].add_child(continue_sprite)
	
	var alternative_sprite: Sprite3D = Sprite3D.new()
	alternative_sprite.texture = alternative_movement_texture
	alternative_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	alternative_sprite.pixel_size = 0.025
	alternative_sprite.position.y += 2
	current_sector.next[1].add_child(alternative_sprite)
	
	await player.chose_next_sector
	
	continue_sprite.queue_free()
	alternative_sprite.queue_free()
