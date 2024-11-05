extends MeshInstance3D


@export var player: Controls.Player
@export var starting_solar_system: SolarSystem
@export var starting_index: int

@onready var move_timer: Timer = $MoveTimer

var current_sector: Sector
var moves_to_move: int = 0


func _ready() -> void:
	current_sector = starting_solar_system.sectors.get_child(starting_index)
	global_position = current_sector.global_position


func _physics_process(delta: float) -> void:
	move()
	
	if Controls.is_action_just_pressed(player, "board_roll_dice"):
		moves_to_move = randi_range(1, 6)


func move() -> void:
	if moves_to_move > 0 and move_timer.is_stopped():
		moves_to_move -= 1
		current_sector = current_sector.next[0]
		global_position = current_sector.global_position
		move_timer.start()
