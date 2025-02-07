class_name MinigamePortrait
extends VBoxContainer


@onready var _texture_rect: TextureRect = $TextureRect
@onready var _label: Label = $Label

func set_minigame(minigame: Minigame) -> void:
	if not is_node_ready():
		await ready
	
	_texture_rect.texture = minigame.portrait
	_label.text = minigame.name
