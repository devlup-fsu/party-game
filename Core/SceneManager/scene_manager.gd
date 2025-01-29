extends Node

signal minigames_command(full_command: String)
signal board_command(full_command: String)

@onready var _player_select_screen_scene: PackedScene = load("res://Core/Controls/player_select_screen.tscn")
@onready var _debug_select_screen: PackedScene = load("res://Core/Minigames/DebugSelectScreen/debug_select_screen.tscn")

var _root: Root
var _scene_stack: Array[Node] = []
var _all_minigames: Array[Minigame] = []


func _ready() -> void:
	await get_parent().ready
	_reroot_scene_tree()
	_init_game_board()
	open_player_select_screen()
	
	Input.joy_connection_changed.connect(func (_controller: int, _connected: bool): open_player_select_screen())
	
	Console.replace_command("minigames", minigames_command)
	minigames_command.connect(_on_minigames_command)
	
	Console.replace_command("board", board_command)
	board_command.connect(_on_board_command)


func _process(_delta: float) -> void:
	# Check that the root node is still valid to check for incorrect minigame scene usage.
	var main_node = get_tree().root.get_child(-1)
	if main_node is not Root or main_node != _root:
		assert(false, "Root node is invalid. Please use the SceneManager API.")
	
	if _scene_stack.is_empty() or _scene_stack[0] is not GameBoard:
		assert(false, "The bottom of the scene stack must be the game board.")
	
	# Open player select screen if button pressed.
	if Input.is_action_just_pressed("core_player_select"):
		open_player_select_screen()


func _on_minigames_command(_full_command: String) -> void:
	_push_scene(_debug_select_screen.instantiate())


func _on_board_command(_full_command: String) -> void:
	_pop_to_board()


## If the "main node" is not Root, reroots the scene tree so that it is.
## This allows for minigames to be directly bootable without going through
## the main menu and game board for easy debugging.
func _reroot_scene_tree() -> void:
	# The main node will be the last child at the root of the scene tree.
	var main_node = get_tree().root.get_child(-1)
	if main_node is Root:
		_root = main_node
		return
	
	# If the main node is not Root, we will reparent the main node to a new Root.
	get_tree().root.remove_child(main_node)
	
	var root_scene: PackedScene = load("res://Core/SceneManager/root.tscn")
	var root: Root = root_scene.instantiate()
	get_tree().root.add_child(root)
	_root = root
	
	_push_scene(main_node)


## Initializes the game board if it was not directly booted.
## Will be placed at the bottom of the scene stack.
func _init_game_board() -> void:
	# If a game board was directly booted, it's already initialized.
	if get_active_scene() is GameBoard:
		return
	
	var game_board_scene: PackedScene = load("res://GameBoard/Boards/board1.tscn")
	var game_board: GameBoard = game_board_scene.instantiate()
	
	# We want the game board to be at the bottom of the stack.
	var temp_scene_stack: Array[Node] = []
	while get_active_scene() != null:
		temp_scene_stack.push_back(_pop_scene())
	
	_push_scene(game_board)
	
	while not temp_scene_stack.is_empty():
		_push_scene(temp_scene_stack.pop_back())


## Pushes the given scene to the top of the scene stack, making it active.
## Deactivates the previously active scene.
func _push_scene(scene: Node, hide_prev: bool = true, pause_prev: bool = true) -> void:
	var active_scene = get_active_scene()
	if active_scene != null:
		if hide_prev:
			active_scene.visible = false
		if pause_prev:
			active_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	_scene_stack.push_back(scene)
	_root.add_child(scene)


## Pops the active scene off of the stack and activates the next active scene.
## The returned scene must be queued free by the caller to avoid a memory leak.
## The returned scene could be null.
func _pop_scene() -> Node:
	var popped_scene = _scene_stack.pop_back()
	_root.remove_child(popped_scene)
	
	var active_scene = get_active_scene()
	if active_scene != null:
		active_scene.visible = true
		active_scene.process_mode = Node.PROCESS_MODE_INHERIT
	
	return popped_scene


func _pop_to_board() -> void:
	while _scene_stack.size() > 1:
		_pop_scene().queue_free()


## Returns the scene at the top of the stack. Can be null if the stack is empty.
func get_active_scene() -> Node:
	return null if _scene_stack.is_empty() else _scene_stack[_scene_stack.size() - 1]


## Opens the player select screen ontop of whatever scene is currently loaded.
func open_player_select_screen() -> void:
	if get_active_scene() is PlayerSelectScreen:
		return
	
	var player_select_screen = _player_select_screen_scene.instantiate()
	_push_scene(player_select_screen)


## Closes the player select screen, returning to the scene loaded before it.
func close_player_select_screen() -> void:
	if get_active_scene() is not PlayerSelectScreen:
		return
	
	_pop_scene().queue_free()


## Returns a cached array of all minigames defined in "Core/Minigames/".
func get_all_minigames() -> Array[Minigame]:
	if not _all_minigames.is_empty():
		return _all_minigames
	
	var dir = DirAccess.open("res://Core/Minigames")
	
	if not dir:
		return []
	
	_all_minigames = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			var resource = ResourceLoader.load("res://Core/Minigames/" + file_name)
			if resource is Minigame:
				_all_minigames.append(resource)
		file_name = dir.get_next()
	
	return _all_minigames


## Loads the provided minigame ontop of the board.
func load_minigame(minigame: Minigame) -> void:
	_pop_to_board()
	
	var minigame_scene = minigame.scene.instantiate()
	_push_scene(minigame_scene)


## Returns to the board and appropriately scores each player.
## Each player receives a "Place" between 1st and 4th. They do not have to be unique.
func exit_minigame(one: Scores.Place, two: Scores.Place, three: Scores.Place, four: Scores.Place) -> void:
	_pop_to_board()
	
	var placements: Dictionary = {}  # Dictionary[Scores.Place, Array[Controls.Player]]
	placements.get_or_add(one, []).push_back(Controls.Player.ONE)
	placements.get_or_add(two, []).push_back(Controls.Player.TWO)
	placements.get_or_add(three, []).push_back(Controls.Player.THREE)
	placements.get_or_add(four, []).push_back(Controls.Player.FOUR)
	
	for place in range(Scores.Place.FIRST, Scores.Place.size()):
		for player in placements.get_or_add(place, []):
			print("%s: Player %s" % [Scores.place_to_string(place), player + 1])
	print()
	
	# TODO: Go to scoring screen to showcase placement.
	# TODO: Actually count the scores for something.
