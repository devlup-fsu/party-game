extends Node3D
class_name FactoryMazeGen

@export var maze_size: float = 27.5
@export var wall_height: float = 3.0
@export var wall_thickness: float = 0.2
@export var maze_translation: Vector3 = Vector3.ZERO
@export var amount_moving_walls: int = 3

const MAZE_JSON_PATH = "res://FactoryGame/maze/mazes.json"
const MAZE_SIZE_MULTIPLIER = 10

var wall_material = preload("res://FactoryGame/resources/wall_material.tres")
var dynamic_wall_script = preload("res://FactoryGame/maze/dynamic_wall.gd")

enum DynamicWallType {
	OSCILLATE,
	ROTATE
}


func vector3_from_array(arr: Array) -> Vector3:
	return Vector3(arr[0], arr[1], arr[2])


func _ready():
	var json_string = FileAccess.get_file_as_string(MAZE_JSON_PATH)
	var mazes_data = JSON.parse_string(json_string)
	var random_maze_data = mazes_data[randi_range(0, len(mazes_data)-1)]
	create_maze_walls(random_maze_data)


func create_wall(wall_position: Vector3, wall_size: Vector3, wall_rotation: float) -> StaticBody3D:
	var wall = StaticBody3D.new()
	
	var wall_collision = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = wall_size
	wall_collision.set_shape(box_shape)
	wall.add_child(wall_collision)
	
	var wall_mesh = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = wall_size
	wall_mesh.mesh = box_mesh
	wall_mesh.material_override = wall_material
	wall.add_child(wall_mesh)
	
	wall.position = wall_position + maze_translation
	wall.rotation = Vector3(0, -wall_rotation, 0)
	wall.set_collision_layer_value(3, true)
	
	return wall


func create_wall_from_segment(size_multiplier: float, half_maze_size: float, segment: Array) -> StaticBody3D:
	var p1 = Vector2(segment[0], segment[1])
	var p2 = Vector2(segment[2], segment[3])
	var wall_length = p1.distance_to(p2)
	var wall_size = Vector3(wall_length*size_multiplier, wall_height, wall_thickness)
	var center = (p1 + p2) / 2
	var wall_position = Vector3(
		center.x * size_multiplier - half_maze_size,
		wall_height / 2,
		center.y * size_multiplier - half_maze_size
	)
	var wall_rotation = atan((p2.y-p1.y) / (p2.x-p1.x))

	return create_wall(wall_position, wall_size, wall_rotation)


func create_dynamic_wall(size_multiplier: float, half_maze_size: float, dynamic_wall_data: Array):
	var wall_segment = dynamic_wall_data[1]
	var wall = create_wall_from_segment(size_multiplier, half_maze_size, wall_segment)
	wall.set_script(dynamic_wall_script)
	
	wall.type = dynamic_wall_data[0] as DynamicWallType
	if wall.type == DynamicWallType.OSCILLATE:
		wall.oscillate_vector = vector3_from_array(dynamic_wall_data[2])
		wall.oscillate_speed = dynamic_wall_data[3]
		wall.oscillate_amplitude = dynamic_wall_data[4]
	
	elif wall.type == DynamicWallType.ROTATE:
		var center = dynamic_wall_data[2]
		wall.rotate_center = Vector2(
			center[0] * size_multiplier - half_maze_size,
			center[1] * size_multiplier - half_maze_size
		)
		wall.rotate_speed = dynamic_wall_data[3]
	else:
		print('Unrecognized dynamic wall type "%d"', % wall.type)
		return null
	
	return wall

func create_maze_walls(maze_data: Dictionary):
	var size_multiplier = maze_size / MAZE_SIZE_MULTIPLIER
	var half_maze_size = maze_size / 2
	for wall_segment: Array in maze_data['static']:	
		var wall = create_wall_from_segment(size_multiplier, half_maze_size, wall_segment)
		add_child(wall)
	
	for dynamic_wall_data: Array in maze_data['dynamic']:
		var wall = create_dynamic_wall(size_multiplier, half_maze_size, dynamic_wall_data)
		if wall != null:
			add_child(wall)
