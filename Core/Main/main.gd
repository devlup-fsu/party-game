class_name Main
extends Node

signal reset_game_command(full_command: String)

@onready var _player_select_screen_scene: PackedScene = load("res://Core/Controls/player_select_screen.tscn")
@onready var _game_board_scene: PackedScene = load("res://GameBoard/Boards/board1.tscn")

@onready var _all_minigames: Array[Minigame] = get_all_minigames()

var _scene_stack: Array[Node] = []


func _ready() -> void:
	open_player_select_screen()
	
	Input.joy_connection_changed.connect(func (controller: int, connected: bool): open_player_select_screen())
	
	Console.replace_command("reset", reset_game_command)
	reset_game_command.connect(_reset_game_command)


func _process(_delta: float):
	if Input.is_action_just_pressed("core_player_select"):
		open_player_select_screen()


func _reset_game_command(full_command: String):
	get_tree().change_scene_to_file("res://Core/Main/main.tscn")


func _on_player_select_screen_start_pressed() -> void:
	if get_active_scene() is PlayerSelectScreen:
		_pop_scene()
		
		if get_active_scene() == null:
			_push_scene(_game_board_scene.instantiate())


func _push_scene(scene: Node):
	var active_scene = get_active_scene()
	if active_scene != null:
		active_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	_scene_stack.push_back(scene)
	add_child(scene)


func _pop_scene():
	var popped_scene = _scene_stack.pop_back()
	popped_scene.queue_free()
	
	var active_scene = get_active_scene()
	if active_scene != null:
		active_scene.process_mode = Node.PROCESS_MODE_INHERIT


func open_player_select_screen() -> void:
	if get_active_scene() is PlayerSelectScreen:
		return
	
	var player_select_screen = _player_select_screen_scene.instantiate()
	_push_scene(player_select_screen)
	player_select_screen.pressed_start.connect(_on_player_select_screen_start_pressed)


func get_active_scene() -> Node:
	return null if _scene_stack.is_empty() else _scene_stack[_scene_stack.size() - 1]


func get_all_minigames() -> Array[Minigame]:
	var dir = DirAccess.open("res://Core/Minigames")
	
	if not dir:
		return []
	
	var minigames: Array[Minigame] = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			var resource = ResourceLoader.load("res://Core/Minigames/" + file_name)
			if resource is Minigame:
				minigames.append(resource)
		file_name = dir.get_next()
	
	return minigames
