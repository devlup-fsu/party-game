extends Node3D

var players: Array[WipeoutPlayer] = []
var player_hit_order: Array[Controls.Player] = []

func _ready() -> void:
	for player in $Players.get_children():
		if player is WipeoutPlayer:
			players.push_back(player)
			player.hit_by_sweeper.connect(_on_player_hit_by_sweeper)


func _process(_delta: float) -> void:
	if players.is_empty():
		SceneManager.exit_minigame(
			player_hit_order.find(Controls.Player.ONE),
			player_hit_order.find(Controls.Player.TWO),
			player_hit_order.find(Controls.Player.THREE),
			player_hit_order.find(Controls.Player.FOUR)
		)


func _on_player_hit_by_sweeper(player: WipeoutPlayer) -> void:
	players.erase(player)
	player_hit_order.push_front(player.player)
