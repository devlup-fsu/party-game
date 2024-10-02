extends Area3D

@export var type: Fuel.FuelType

func _ready() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = Fuel.FUEL_COLORS[type]
	material.roughness = 0.2
	$StaticBody3D/MeshInstance3D.set_surface_override_material(0, material)

func _on_body_entered(body: Node3D) -> void:
	if body is Fuel and body.carrier != null and body.type == type:
		if body.carrier.carried_fuel_node == body:
			body.carrier.carried_fuel_node = null
		body.carrier.points += 1
		body.parent_generator.parent.amount_fuel_objects -= 1
		body.queue_free()
