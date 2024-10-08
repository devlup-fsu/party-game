extends RigidBody3D
class_name Fuel

var parent_generator: FuelGenerator = null
var near_generator: bool = true
var carrier: FactoryPlayer = null
var ifDangerous: bool = false # check for if a fuel cell can stun a player

enum FuelType {
	RED,
	BLUE,
	YELLOW,
	GREEN
}
var type: FuelType = FuelType.RED

const FUEL_COLORS = [
	Color('#FF0000'),
	Color('#0000FF'),
	Color('#FFFF00'),
	Color('#00FF00')
]	

func set_type(new_type: FuelType):
	type = new_type
	var material := StandardMaterial3D.new()
	var fuel_color = FUEL_COLORS[type]
	material.albedo_color = fuel_color
	material.emission_enabled = true
	material.emission = fuel_color
	
	$MeshInstance3D.set_surface_override_material(0, material)
	$OmniLight3D.light_color = fuel_color
