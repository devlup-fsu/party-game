extends Node

enum Player {
	ONE,
	TWO,
	THREE,
	FOUR,
	COUNT
}

# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[Player, int]
var _player_controllers: Dictionary = {}


func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _on_joy_connection_changed(controller: int, connected: bool) -> void:
	# TODO: Force open player select screen when controllers change
	
	print("Controller %s was %s" % [controller, "connected" if connected else "disconnected"])
	
	if not connected:
		var player: Controls.Player = _player_controllers.find_key(controller)
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


func unassign_all_controllers() -> void:
	_player_controllers.clear()
