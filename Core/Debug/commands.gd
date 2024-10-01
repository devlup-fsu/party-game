extends Node


class ToggleCommand:
	var enabled: bool = false
	var on_enabled: Callable = func (_command: String) -> bool: return true
	var on_disabled: Callable = func (_command: String) -> bool: return true
	
	func _init(_enabled: bool, _on_enabled, _on_disabled):
		self.enabled = _enabled
		if _on_enabled != null:
			self.on_enabled = _on_enabled
		if _on_disabled != null:
			self.on_disabled = _on_disabled



# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[StringName, ToggleCommand]
var _toggles: Dictionary = {}
# TODO: In Godot 4.4, dictionaries can be typed. Will be Dictionary[StringName, Callable]
var _one_shots: Dictionary = {}


func _ready() -> void:
	register_one_shot("say_hi", func (command: String) -> bool:
		var parts = command.split(" ")
		if len(parts) < 2:
			return false
		print(" ".join(parts.slice(1)))
		return true
	)
	try_run_command("say_hi Hello World!")


## on_enabled and on_disabled should have a function signature of
## func (command: String) -> bool
## where command is the full raw command and
## where the function returns true if the command succeeds, false otherwise.
func register_toggle(command_name: StringName, starts_enabled: bool = false, on_enabled = null, on_disabled = null) -> void:
	command_name = command_name.to_lower()
	
	assert(not command_name.contains(" "), "Command '%s' cannot be registered because it contains a space." % command_name)
	assert(command_name not in _toggles, "Command '%s' cannot be registered because it has already been registered." % command_name)
	
	_toggles[command_name] = ToggleCommand.new(starts_enabled, on_enabled, on_disabled)


func is_toggle_registered(command_name: StringName) -> bool:
	return command_name.to_lower() in _toggles


func is_toggle_enabled(command_name: StringName) -> bool:
	command_name = command_name.to_lower()
	
	if command_name in _toggles:
		return _toggles[command_name].enabled
	return false


func try_enable_toggle(command: String) -> bool:
	var parts: PackedStringArray = command.split(" ", false)
	
	if len(parts) < 2 and parts[0].to_lower() != "enable":
		return false
	
	var command_name = parts[1].to_lower()
	
	if command_name in _toggles:
		var toggle: ToggleCommand = _toggles[command_name]
		
		if not toggle.enabled and toggle.on_enabled.call(command):
			toggle.enabled = true
			return true
	
	return false


func try_disable_toggle(command: String) -> bool:
	var parts: PackedStringArray = command.split(" ", false)
	
	if parts[0].to_lower() != "disable":
		return false
	
	var command_name = parts[1].to_lower()
	
	if command_name in _toggles:
		var toggle: ToggleCommand = _toggles[command_name]
		
		if toggle.enabled and toggle.on_disabled.call(command):
			toggle.enabled = false
			return true
	
	return false


## on_run should have the function signature of
## func (command: String) -> bool
## where command is the full raw command and
## where the function returns true if the command succeeds, false otherwise.
func register_one_shot(command_name: StringName, on_run: Callable) -> void:
	command_name = command_name.to_lower()
	
	assert(not command_name.contains(" "), "Command '%s' cannot be registered because it contains a space." % command_name)
	assert(command_name not in _one_shots, "Command '%s' cannot be registered because it has already been registered." % command_name)
	
	_one_shots[command_name] = on_run


func is_one_shot_registered(command_name: StringName) -> bool:
	return command_name.to_lower() in _one_shots


func try_run_command(command: String) -> bool:
	var parts: PackedStringArray = command.split(" ", false)
	
	if len(parts) < 1:
		return false
	
	var command_name = parts[0].to_lower()
	
	if command_name in _one_shots:
		var callback: Callable = _one_shots[command_name]
		
		return callback.call(command)
	
	return false
