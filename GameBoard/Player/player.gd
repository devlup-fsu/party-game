class_name BoardPlayer
extends Node3D

signal choosing_next_sector(player: BoardPlayer, current_sector: Sector)
signal chose_next_sector
signal finished_turn

const PLAYER_COLORS = [Color.LIME_GREEN, Color.DARK_RED, Color.ROYAL_BLUE, Color.ORANGE]

@export var player: Controls.Player
@export var starting_solar_system: SolarSystem
@export var starting_index: int

@onready var move_counter_label: Label3D = $MoveCounter

@onready var ship_model: ShipModel = $ShipModel

var current_sector: Sector
var next_sector: Sector
var has_control: bool = false
var ongoing_moves: int = 0
var rand_hover_offset = randf_range(0, 10)


func _ready() -> void:
	ship_model.player = player
	
	current_sector = starting_solar_system.sectors.get_child(starting_index)
	current_sector.player = self
	global_position = current_sector.global_position
	global_rotation.y = current_sector.global_rotation.y


func _physics_process(delta: float) -> void:
	global_position.y = current_sector.global_position.y
	global_position.y += sin(PI * (Time.get_unix_time_from_system() + rand_hover_offset) / 2) / 4
	
	var move_counter = ongoing_moves - 1
	move_counter_label.text = str(move_counter) if move_counter > 0 else ""
	
	if not has_control:
		return
	
	if ongoing_moves > 0:
		if next_sector != null:
			global_position.x = lerp(global_position.x, next_sector.get_player_position().x, delta * 10)
			global_position.z = lerp(global_position.z, next_sector.get_player_position().z, delta * 10)
			global_rotation.y = lerp_angle(global_rotation.y, next_sector.global_rotation.y, delta * 10)
			if abs(global_position.x - next_sector.global_position.x) <= 0.1 && abs(global_position.z - next_sector.global_position.z) <= 0.1:
				current_sector = next_sector
				if not current_sector.is_occupied():
					ongoing_moves -= 1
				if ongoing_moves > 0:
					_choose_next_sector()
				else:
					current_sector.player = self
					has_control = false
					finished_turn.emit()
		else:
			if Controls.is_action_just_pressed(player, "board_continue_movement"):
				next_sector = current_sector.next[0]
				chose_next_sector.emit()
			elif Controls.is_action_just_pressed(player, "board_alternative_movement"):
				next_sector = current_sector.next[1]
				chose_next_sector.emit()
	elif Controls.is_action_just_pressed(player, "board_roll_dice"):
		move_n_sectors(randi_range(1, 6))


func take_control() -> void:
	has_control = true


func move_n_sectors(n: int) -> void:
	current_sector.player = null
	ongoing_moves = n
	_choose_next_sector()


func _choose_next_sector() -> void:
	next_sector = null
	if current_sector.next.size() == 1:
		next_sector = current_sector.next[0]
	else:
		choosing_next_sector.emit(self, current_sector)
