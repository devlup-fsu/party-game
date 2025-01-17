extends Node


enum Player {
	ONE,
	TWO,
	THREE,
	FOUR
}


# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[Player, int]
var _player_controllers: Dictionary = {}
# TODO: Type as Dictionary[Player, Dictionary[StringName, bool]]
var _player_actions: Dictionary = {}
# TODO: Type as Dictionary[Player, Dictionary[StringName, bool]]
var _immediate_player_actions: Dictionary = {}
# TODO: Type as Dictionary[Player, Dictionary[StringName, bool]]
var _immediate_player_actions_buffer: Dictionary = {}
# TODO: type as Dictionary[Player, Dictionary[StringName, float]]
var _player_action_strength: Dictionary = {}


const JOYSTICK_DEADZONE = 0.05


func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	for player in range(Player.ONE, Player.size()):
		_player_actions[player] = {}
		_immediate_player_actions[player] = {}
		_immediate_player_actions_buffer[player] = {}
		_player_action_strength[player] = {}


func _physics_process(_delta: float) -> void:
	_immediate_player_actions = _immediate_player_actions_buffer.duplicate(true)
	
	for player in range(Player.ONE, Player.size()):
		_immediate_player_actions_buffer[player].clear()


func _input(event: InputEvent) -> void:
	if not event.is_action_type():
		return
	
	var player = _player_controllers.find_key(event.device)
	
	if event is InputEventKey:
		player = Player.ONE
	
	if player == null:
		return
	
	for action: StringName in InputMap.get_actions():
		if event is InputEventJoypadMotion:
			if event.is_action(action):
				var stick_moved = abs(event.axis_value) > JOYSTICK_DEADZONE
				_player_actions[player][action] = stick_moved
				_player_action_strength[player][action] = event.axis_value if stick_moved else 0.0
		else:
			if event.is_action_pressed(action):
				if not _player_actions[player].get_or_add(action, false):
					_player_actions[player][action] = true
					_immediate_player_actions_buffer[player][action] = true
			elif event.is_action_released(action):
				_player_actions[player][action] = false
				_immediate_player_actions_buffer[player][action] = false


func _on_joy_connection_changed(controller: int, connected: bool) -> void:
	print("Controller %s was %s" % [controller, "connected" if connected else "disconnected"])
	
	if not connected:
		var player = _player_controllers.find_key(controller)
		if player != null:
			_player_controllers.erase(player)


# Returns -1 if player has no controller.
func get_controller_of_player(player: Player) -> int:
	if _player_controllers.has(player):
		return _player_controllers[player]
	
	return -1


func try_assign_player_controller(player: Player, controller: int) -> bool:
	if player not in _player_controllers:
		var old_player = _player_controllers.find_key(controller)
		if old_player != null:
			_player_controllers.erase(old_player)
		
		_player_controllers[player] = controller
		return true
	
	return false


func try_unassign_player_controller(player: Player) -> bool:
	if player in _player_controllers.keys():
		_player_controllers.erase(player)
		return true
	
	return false


func get_assigned_player_count() -> int:
	return _player_controllers.keys().size()


func unassign_all_controllers() -> void:
	_player_controllers.clear()


func is_action_pressed(player: Player, action: StringName) -> bool:
	return _player_actions[player].get_or_add(action, false)


func is_action_just_pressed(player: Player, action: StringName) -> bool:
	return _immediate_player_actions[player].get_or_add(action, false)


func get_action_strength(player: Player, action: StringName) -> float:
	if _player_action_strength[player].has(action):
		return _player_action_strength[player][action]
	
	return 1.0 if is_action_pressed(player, action) else 0.0


func get_axis(player: Player, negative_action: StringName, positive_action: StringName) -> float:
	if get_controller_of_player(player) != -1:  # If using a controller
		return get_action_strength(player, positive_action)
	return abs(get_action_strength(player, positive_action)) - abs(get_action_strength(player, negative_action))


func get_vector(player: Player, negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName) -> Vector2:
	return Vector2(get_axis(player, negative_x, positive_x), get_axis(player, negative_y, positive_y))
