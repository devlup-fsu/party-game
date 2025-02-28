class_name MinigamePortrait
extends VBoxContainer


@onready var _texture_rect: TextureRect = $TextureRect
@onready var _label: Label = $Label

var minigame: Minigame:
	set(value):
		minigame = value
		if not is_node_ready():
			await ready
		
		_texture_rect.texture = minigame.portrait
		_label.text = minigame.name
	get:
		return minigame
