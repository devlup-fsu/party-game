extends VBoxContainer


@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func set_minigame(minigame: Minigame) -> void:
	if not is_node_ready():
		await ready
	
	texture_rect.texture = minigame.portrait
	label.text = minigame.name
