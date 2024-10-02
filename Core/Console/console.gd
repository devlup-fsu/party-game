extends CanvasLayer


signal print_command(full_command: String)


@onready var output: RichTextLabel = %Output
@onready var input: LineEdit = %Input


# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[StringName, Signal]
var _commands: Dictionary = {}


func _ready() -> void:
	visible = false
	
	print_command.connect(func (full_command: String) -> void:
		var parts = full_command.split(" ")
		if len(parts) < 2:
			return
		
		print(parts.slice(1))
	)
	
	register_command("print", print_command)


func _process(_delta: float) -> void:
	# TODO: Only launch the console when game is launched from the editor.
	if Input.is_action_just_pressed("core_debug_console"):
		visible = not visible


func _on_input_text_submitted(new_text: String) -> void:
	output.append_text(new_text + "\n")
	input.clear()
	
	run_command(new_text)


func register_command(command_name: StringName, action: Signal) -> void:
	assert(command_name == command_name.to_lower(), "Can't register command '%s' with uppercase letters." % command_name)
	assert(not command_name.contains(" "), "Can't register command '%s' with space characters." % command_name)
	assert(command_name not in _commands, "Can't register command '%s' that has already been registered." % command_name)
	
	_commands[command_name] = action


func run_command(full_command: String) -> void:
	var parts = full_command.split(" ")
	if len(parts) < 1:
		return
		
	var command_name = parts[0].to_lower()
	
	if command_name in _commands:
		_commands[command_name].emit(full_command)
