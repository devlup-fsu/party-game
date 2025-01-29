class_name ConsoleCLI
extends CanvasLayer

@onready var _output: RichTextLabel = %Output
@onready var _input: LineEdit = %Input

var _history_index: int

func _ready() -> void:
	_output.append_text(Console.get_output())
	_input.grab_focus()
	_history_index = Console.get_input_history().size()
	
	Console.output_appended.connect(_on_console_output_appended)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("core_debug_console") or Input.is_action_just_pressed("core_debug_console_close"):
		if SceneManager.get_active_scene() == self:
			SceneManager._pop_scene().queue_free()


func _on_console_output_appended(line: String) -> void:
	_output.append_text(line)


func _on_input_text_submitted(full_command: String) -> void:
	_input.clear()
	
	var parts = full_command.split(" ")
	
	if parts.size() <= 0:
		return
	
	Console.append_input_history(full_command)
	_history_index = Console.get_input_history().size()
	
	var command_name = parts[0]
	
	if Console.is_command_registered(command_name):
		Console.run_command(full_command)
	elif Console.is_toggle_registered(command_name):
		Console.toggle_toggle(command_name)
		Console.write("'%s' has been %s." % [command_name, "enabled" if Console.is_toggle_enabled(command_name) else "disabled"])
	else:
		Console.error("'%s' is an invalid command or toggle." % command_name)


func _on_input_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.pressed:
		var input_history = Console.get_input_history()
		
		if event.keycode == KEY_UP:
			if _history_index > 0:
				_history_index -= 1
				_input.clear()
				_input.insert_text_at_caret(input_history[_history_index])
		elif event.keycode == KEY_DOWN:
			if _history_index < input_history.size():
				_history_index += 1
				_input.clear()
				if _history_index < input_history.size():
					_input.insert_text_at_caret(input_history[_history_index])
		else:
			_history_index = input_history.size()
