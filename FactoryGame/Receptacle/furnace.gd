extends Area3D

@export var player: FactoryPlayer

func _ready() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = FactoryPlayer.PLAYER_COLORS[player.player_number]
	material.roughness = 0.2
	$StaticBody3D/MeshInstance3D.set_surface_override_material(0, material)

func _on_body_entered(body: Node3D) -> void:
	if body is Fuel:
		if body.carrier != null and body.carrier.carried_fuel_node == body:  # Walked into furnace
			body.carrier.carried_fuel_node = null
			body.carrier.reset_throw_charge()
		player.points += 1
		body.parent_generator.parent.amount_fuel_objects -= 1
		body.queue_free()
