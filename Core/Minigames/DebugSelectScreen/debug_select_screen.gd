class_name DebugSelectScreen
extends Control


signal load_minigame(minigame: Minigame)


func initialize(minigames: Array[Minigame]) -> void:
	for minigame in minigames:
		var button = Button.new()
		add_child(button)
		button.text = minigame.name
		button.pressed.connect(_on_button_pressed.bind(minigame))


func _on_button_pressed(minigame: Minigame):
	load_minigame.emit(minigame)
