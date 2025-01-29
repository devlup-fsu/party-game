class_name DebugSelectScreen
extends Control

@onready var v_box: VBoxContainer = %VBoxContainer


func _ready() -> void:
	for minigame in SceneManager.get_all_minigames():
		var button = Button.new()
		v_box.add_child(button)
		button.text = minigame.name
		button.pressed.connect(_on_button_pressed.bind(minigame))


func _on_button_pressed(minigame: Minigame):
	SceneManager.load_minigame(minigame)
