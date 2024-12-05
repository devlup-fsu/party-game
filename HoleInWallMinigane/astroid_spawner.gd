extends Node3D

@onready var Astroid: PackedScene = load("res://HoleInWallMinigane/Astroid.tscn")
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if(timer <= 0):
		var AstroidInstance = Astroid.instantiate()
		add_child(AstroidInstance)
		timer = 10
