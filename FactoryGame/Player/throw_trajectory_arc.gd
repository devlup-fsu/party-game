extends MeshInstance3D
 
 
@onready var parent: FactoryPlayer = get_parent()
 
var num_points = 50
var dot_length = 0.01
var gap_length = 0.02
var gravity = 20

var immediate_mesh: ImmediateMesh
 
func _ready() -> void:
	immediate_mesh = ImmediateMesh.new()
	mesh = immediate_mesh
 
 
func _process(_delta: float) -> void:
	if parent.throw_charge == 0.0:
		mesh.clear_surfaces()
		return
	
	rotation = Vector3(0.0, -atan2(parent.facing_direction.z, parent.facing_direction.x), 0.0)
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_set_color(Color(1.0, 1.0, 1.0))
 	
	
	var throw_strength = parent.get_throw_strength()
	var parent_lateral_velocity = Vector2(parent.velocity.x, parent.velocity.z).abs()
	var initial_velocity = Vector2(parent.facing_direction.length(), parent.THROW_STRENGTH_VERTICAL) \
		* throw_strength \
		* parent.THROW_STRENGTH_HORIZONTAL \
		+ (parent_lateral_velocity * parent.THROW_STRENGTH_PLAYER_VELOCITY_INFLUENCE)
	var x = 0.0
 
	for i in range(num_points):
		var p1x = initial_velocity.x * x
		var p1y = initial_velocity.y * x - 0.5 * gravity * x*x
		var p1 = Vector3(p1x, p1y, 0)
		x += dot_length
		var p2x = initial_velocity.x * x
		var p2y = initial_velocity.y * x - 0.5 * gravity * x*x
		var p2 = Vector3(p2x, p2y, 0)
		x += gap_length
 
		mesh.surface_add_vertex(p1)
		mesh.surface_add_vertex(p2)
 
	mesh.surface_end()
