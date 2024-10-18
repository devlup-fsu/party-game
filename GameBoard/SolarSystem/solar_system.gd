extends Node3D

@export var radius: float = 5
@export var sectors: int = 12
@export_range(-180, 180, 0.001, "radians_as_degrees") var radial_offset: float = 0
@export var color: Color
