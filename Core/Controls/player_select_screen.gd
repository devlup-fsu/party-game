class_name PlayerSelectScreen
extends Node3D

@onready var _selected_labels: Array[Label] = [
	%Player1/Selected,
	%Player2/Selected,
	%Player3/Selected,
	%Player4/Selected
]
@onready var _start_game_label: Label = %StartGameLabel


func _ready() -> void:
	Controls.unassign_all_controllers()


func _physics_process(_delta: float) -> void:
	_update_labels()
	
	for player in range(Controls.Player.ONE, Controls.Player.size()):
		if Controls.is_action_just_pressed(player, "core_submit"):
			SceneManager.close_player_select_screen()


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index < JOY_BUTTON_A or event.button_index > JOY_BUTTON_Y:
			return
		
		# JOY_BUTTON_A through JOY_BUTTON_Y correspond to Player.ONE through Player.THREE
		var player: Controls.Player = event.button_index
		
		if Controls.get_controller_of_player(player) == event.device:
			Controls.try_unassign_player_controller(player)
		else:
			Controls.try_assign_player_controller(player, event.device)


func _update_labels() -> void:
	for player in range(Controls.Player.ONE, Controls.Player.size()):
		var selected := Controls.get_controller_of_player(player) != -1
		
		_selected_labels[player].text = "Selected" if selected else ""
	
	if Controls.get_assigned_player_count() == Controls.Player.size():
		_start_game_label.text = "Press START to play the game!"
	else:
		_start_game_label.text = ""
