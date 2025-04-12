extends Node2D
class_name FadeScene

const FADE_TIME = 1.0

## Whether to fade to black (true) or fade in from black (false).
var fade_type: bool = true

## The function to call when the fade is finished.
var on_finish: Callable

var fade_timer: float = 0.0


func _ready() -> void:
	if fade_type == false:
		$FadeRect.color.a = 1.0
	

func _process(delta: float) -> void:
	fade_timer = move_toward(fade_timer, FADE_TIME, delta)
	if fade_timer >= FADE_TIME:
		self.on_finish.call()
	else:
		var alpha: float
		if fade_type:  # fade out
			alpha = remap(fade_timer, 0.0, FADE_TIME, 0.0, 1.0)
		else:
			alpha = remap(fade_timer, 0.0, FADE_TIME, 1.0, 0.0)
		$FadeRect.color.a = alpha
