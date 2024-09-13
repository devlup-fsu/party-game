extends HBoxContainer

@onready var _selected_labels: Array[Label] = [
	%Player1/Selected,
	%Player2/Selected,
	%Player3/Selected,
	%Player4/Selected
]


func _ready() -> void:
	Controls.unassign_all_controllers()


func _process(_delta: float) -> void:
	_update_selected_labels()


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


func _update_selected_labels() -> void:
	for player in range(Controls.Player.ONE, Controls.Player.COUNT):
		var selected := Controls.get_controller_of_player(player) != -1
		
		_selected_labels[player].text = "Selected" if selected else ""
