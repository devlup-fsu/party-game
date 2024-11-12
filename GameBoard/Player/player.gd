class_name BoardPlayer
extends Node3D

signal choosing_next_sector(player: BoardPlayer, current_sector: Sector)
signal chose_next_sector

@export var player: Controls.Player
@export var starting_solar_system: SolarSystem
@export var starting_index: int

@onready var move_counter_label: Label3D = $MoveCounter

var current_sector: Sector
var next_sector: Sector
var ongoing_moves: int = 0


func _ready() -> void:
	current_sector = starting_solar_system.sectors.get_child(starting_index)
	global_position = current_sector.global_position
	global_rotation.y = current_sector.global_rotation.y


func _physics_process(delta: float) -> void:
	move_counter_label.text = str(ongoing_moves) if ongoing_moves > 0 else ""
	
	if ongoing_moves > 0:
		if next_sector != null:
			global_position = global_position.lerp(next_sector.global_position, delta * 10)
			global_rotation.y = lerp_angle(global_rotation.y, next_sector.global_rotation.y, delta * 10)
			if global_position.distance_to(next_sector.global_position) <= 0.1:
				current_sector = next_sector
				ongoing_moves -= 1
				if ongoing_moves > 0:
					_choose_next_sector()
		else:
			if Controls.is_action_just_pressed(player, "board_continue_movement"):
				next_sector = current_sector.next[0]
				chose_next_sector.emit()
			elif Controls.is_action_just_pressed(player, "board_alternative_movement"):
				next_sector = current_sector.next[1]
				chose_next_sector.emit()
	else:
		if Controls.is_action_just_pressed(player, "board_roll_dice"):
			move_n_sectors(randi_range(1, 6))


func move_n_sectors(n: int) -> void:
	ongoing_moves = n
	_choose_next_sector()


func is_moving() -> bool:
	return ongoing_moves > 0


func _choose_next_sector() -> void:
	next_sector = null
	if current_sector.next.size() == 1:
		next_sector = current_sector.next[0]
	else:
		choosing_next_sector.emit(self, current_sector)
