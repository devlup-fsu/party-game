class_name Main
extends Node

@onready var _player_select_screen_scene: PackedScene = load("res://Core/Controls/player_select_screen.tscn")
@onready var _debug_select_screen_scene: PackedScene = load("res://Core/Minigames/DebugSelectScreen/debug_select_screen.tscn")

@onready var _all_minigames: Array[Minigame] = get_all_minigames()

var _player_select_screen: PlayerSelectScreen = null
var _debug_select_screen: DebugSelectScreen = null
var _current_minigame: Minigame = null
var _current_minigame_scene: Node = null


func _ready() -> void:
	open_player_select_screen()
	
	Input.joy_connection_changed.connect(func (controller: int, connected: bool): open_player_select_screen())


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("core_debug_restart"):
		get_tree().change_scene_to_file("res://Core/Main/main.tscn")


func _on_player_select_screen_start_pressed() -> void:
	if _player_select_screen != null:
		_player_select_screen.queue_free()
		_player_select_screen = null
		
		if _current_minigame_scene != null:
			_current_minigame_scene.process_mode = Node.PROCESS_MODE_INHERIT
		elif _debug_select_screen != null:
			_debug_select_screen.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			_debug_select_screen = _debug_select_screen_scene.instantiate()
			add_child(_debug_select_screen)
			_debug_select_screen.initialize(_all_minigames)
			_debug_select_screen.load_minigame.connect(_on_debug_select_screen_load_minigame)


func _on_debug_select_screen_load_minigame(minigame: Minigame) -> void:
	if _debug_select_screen != null:
		_debug_select_screen.queue_free()
		_debug_select_screen = null
		
		_current_minigame = minigame
		_current_minigame_scene = minigame.scene.instantiate()
		add_child(_current_minigame_scene)


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


func open_player_select_screen() -> void:
	print("Open")
	if _player_select_screen != null:
		return
	
	if _current_minigame_scene != null:
		_current_minigame_scene.process_mode = Node.PROCESS_MODE_DISABLED
	elif _debug_select_screen != null:
		_debug_select_screen.process_mode = Node.PROCESS_MODE_DISABLED
	
	_player_select_screen = _player_select_screen_scene.instantiate()
	add_child(_player_select_screen)
	_player_select_screen.pressed_start.connect(_on_player_select_screen_start_pressed)
