extends Node

signal output_appended(line: String)

signal list_command(full_command: String)
signal enable_toggle_command(full_command: String)
signal disable_toggle_command(full_command: String)

@onready var console_cli_scene: PackedScene = load("res://Core/Console/console_cli.tscn")

# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[StringName, Signal]
var _commands: Dictionary = {}
# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[StringName, bool]
var _toggles: Dictionary = {}

var _output: String = ""
var _input_history: Array[String] = []


func _ready() -> void:
	register_command("list", list_command)
	list_command.connect(_on_list_command)
	
	register_command("enable", enable_toggle_command)
	enable_toggle_command.connect(_on_enable_toggle_command)
	
	register_command("disable", disable_toggle_command)
	disable_toggle_command.connect(_on_disable_toggle_command)


func _on_list_command(full_command: String) -> void:
	var parts = full_command.split(" ")
	
	if parts.size() <= 1 or (parts[1] != "commands" and parts[1] != "toggles"):
		warn("To list commands, run 'list commands'.")
		warn("To list toggles, run 'list toggles'.")
	elif parts[1] == "commands":
		write("===== Registered Commands =====")

		var command_names = _commands.keys()
		for i in range(command_names.size()):
			write("%d. %s" % [i + 1, command_names[i]])

		write()
	elif parts[1] == "toggles":
		write("===== Registered Toggles =====")

		var toggle_names = _toggles.keys()
		for i in range(toggle_names.size()):
			write("%d. %s" % [i + 1, toggle_names[i]])

		write()


func _on_enable_toggle_command(full_command: String) -> void:
	var parts = full_command.split(" ")
	
	if parts.size() <= 1:
		warn("To enable a toggle, run 'enable <toggle_name>'.")
	elif not is_toggle_registered(parts[1]):
		error("'%s' is an invalid toggle." % parts[1])
	else:
		enable_toggle(parts[1])
		write("'%s' has been enabled." % parts[1])


func _on_disable_toggle_command(full_command: String) -> void:
	var parts = full_command.split(" ")
	
	if parts.size() <= 1:
		warn("To disable a toggle, run 'disable <toggle_name>'.")
	elif not is_toggle_registered(parts[1]):
		error("'%s' is an invalid toggle." % parts[1])
	else:
		disable_toggle(parts[1])
		write("'%s' has been disabled." % parts[1])


func _process(_delta: float) -> void:
	# TODO: Only launch the console when game is launched from the editor.
	if Input.is_action_just_pressed("core_debug_console"):
		if SceneManager.get_active_scene() is not ConsoleCLI:
			SceneManager._push_scene(console_cli_scene.instantiate(), false)


func _append_output(line: String) -> void:
	_output += line
	output_appended.emit(line)


## Registers a command and associates it with a given signal.
## Command names must be unique and all lowercase. They cannot be registered more than once.
func register_command(command_name: StringName, action: Signal) -> void:
	assert(command_name == command_name.to_lower(), "Can't register command '%s' with uppercase letters." % command_name)
	assert(not command_name.contains(" "), "Can't register command '%s' with space characters." % command_name)
	assert(command_name not in _commands, "Can't register command '%s' that has already been registered." % command_name)
	assert(command_name not in _toggles, "Can't register command '%s' that has already been registered as a toggle." % command_name)
	
	_commands[command_name] = action


func replace_command(command_name: StringName, action: Signal) -> void:
	assert(command_name == command_name.to_lower(), "Can't register command '%s' with uppercase letters." % command_name)
	assert(not command_name.contains(" "), "Can't register command '%s' with space characters." % command_name)
	assert(command_name not in _toggles, "Can't register command '%s' that has already been registered as a toggle." % command_name)
	
	_commands[command_name] = action


func is_command_registered(command_name: StringName) -> bool:
	return command_name in _commands


## Runs the signal associated with the command. If the command doesn't exist,
## this function will fail silently.
func run_command(full_command: String) -> void:
	var parts = full_command.split(" ")
	if len(parts) < 1:
		return
		
	var command_name = parts[0].to_lower()
	
	if command_name in _commands:
		_commands[command_name].emit(full_command)


## Registers a toggle with a default value. Unlike a command a toggle is not
## associated with a signal, but instead is enabled or disabled.
## The toggle can be toggled with simply its name, or, can be explicitly
## enabled/disabled with the 'enabled' and 'disabled' commands.
func register_toggle(toggle_name: StringName, default_value: bool = false) -> void:
	assert(toggle_name == toggle_name.to_lower(), "Can't register toggle '%s' with uppercase letters." % toggle_name)
	assert(not toggle_name.contains(" "), "Can't register toggle '%s' with space characters." % toggle_name)
	assert(toggle_name not in _toggles, "Can't register toggle '%s' that has already been registered." % toggle_name)
	assert(toggle_name not in _commands, "Can't register toggle '%s' that has already been registered as a command." % toggle_name)
	
	_toggles[toggle_name] = default_value


func is_toggle_registered(toggle_name: StringName) -> bool:
	return toggle_name in _toggles


func is_toggle_enabled(toggle_name: StringName) -> bool:
	return _toggles.get(toggle_name, false)


## Flips the state of a toggle. true -> false, false -> true
func toggle_toggle(toggle_name: StringName) -> void:
	if is_toggle_registered(toggle_name):
		_toggles[toggle_name] = not _toggles[toggle_name]


func enable_toggle(toggle_name: StringName) -> void:
	if is_toggle_registered(toggle_name):
		_toggles[toggle_name] = true


func disable_toggle(toggle_name: StringName) -> void:
	if is_toggle_registered(toggle_name):
		_toggles[toggle_name] = false


## Writes the message to the in-game console with no color.
func write(message: Variant = "", end = "\n") -> void:
	_append_output(str(message).replace("[", "[lb]") + end)


## Writes the message to the in-game console with an orange color.
func warn(message: Variant = "", end = "\n") -> void:
	_append_output("[color=orange]%s[/color]" % str(message).replace("[", "[lb]") + end)


## Writes the message to the in-game console with a red color.
func error(message: Variant = "", end = "\n") -> void:
	_append_output("[color=red]%s[/color]" % str(message).replace("[", "[lb]") + end)


func get_output() -> String:
	return _output


func get_input_history() -> Array[String]:
	return _input_history


func append_input_history(full_command: String) -> void:
	_input_history.push_back(full_command)
