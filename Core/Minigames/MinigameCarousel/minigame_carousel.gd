class_name MinigameCarousel
extends Control

const BORDER_WIDTH: Vector2 = Vector2.ONE * 8

var _portrait_scene: PackedScene = load("res://Core/Minigames/MinigameCarousel/minigame_portrait.tscn")

var _portraits: Array[MinigamePortrait] = []
var _target_minigame: Minigame
var _selector_idx: int = 0
var _time: float = 0

func initialize(target_minigame: Minigame) -> void:
	_target_minigame = target_minigame
	if not is_node_ready():
		await ready
	
	var minigames = SceneManager.get_published_minigames()
	minigames += minigames + minigames
	minigames.erase(target_minigame)
	minigames.shuffle()
	minigames = minigames.slice(0, 3)  # Get three random minigames.
	minigames.append(target_minigame)
	minigames.shuffle()
	
	for minigame in minigames:
		var portrait: MinigamePortrait = _portrait_scene.instantiate()
		_portraits.push_back(portrait)
		%Portraits.add_child(portrait)
		
		portrait.minigame = minigame
	
	%Selector.size = _portraits[0].size + BORDER_WIDTH * 2
	_on_move_selector_timer_timeout()

func _process(delta: float) -> void:
	_time += delta

func interpolation_fun(time: float) -> float:
	return 0.5/(1+exp((time - 2) * -2)) + 0.05

func _on_move_selector_timer_timeout() -> void:
	%Selector.global_position = _portraits[_selector_idx].global_position - BORDER_WIDTH
	_selector_idx = (_selector_idx + 1) % 4
	
	if _time >= 5 and _portraits[_selector_idx].minigame == _target_minigame:
		pass
	else:
		get_tree().create_timer(interpolation_fun(_time)).timeout.connect(_on_move_selector_timer_timeout, CONNECT_ONE_SHOT)
