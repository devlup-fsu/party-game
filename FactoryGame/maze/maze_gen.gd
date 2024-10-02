extends Node3D

@export var maze_size: int = 6
@export var cell_size: float = 5.0
@export var wall_height: float = 3.0
@export var wall_thickness: float = 0.2
@export var maze_translation: Vector3 = Vector3.ZERO
@export var center_radius: int = 1
@export var amount_moving_walls: int = 3

var wall_material = preload("res://FactoryGame/resources/wall_material.tres")
var moving_wall_script = preload("res://FactoryGame/maze/moving_wall.gd")

var walls: Array

func _ready():
	var maze = generate_maze()
	maze_post_processing(maze)
	for row in maze:
		print(row)
	create_maze_walls(maze)

func generate_maze() -> Array:
	# Initialize the maze with walls
	var maze = []
	for x in range(maze_size * 2 + 1):
		var row = []
		for y in range(maze_size * 2 + 1):
			row.append(1)  # 1 represents a wall
		maze.append(row)
	
	# Generate the maze using recursive backtracking
	var stack = []
	var start_x = 1
	var start_y = 1
	
	maze[start_x][start_y] = 0  # 0 represents a path
	stack.push_back(Vector2(start_x, start_y))
	
	while not stack.is_empty():
		var current = stack.back()
		var neighbors = get_unvisited_neighbors(maze, current.x, current.y)
		
		if neighbors.is_empty():
			stack.pop_back()
		else:
			var next = neighbors[randi() % neighbors.size()]
			var direction = next - current
			
			maze[next.x][next.y] = 0
			maze[current.x + direction.x / 2][current.y + direction.y / 2] = 0
			
			stack.push_back(next)
	return maze

func maze_post_processing(maze: Array):
	var edge_data = [
		func(n): return Vector2(0, n*2-1),  # top
		func(n): return Vector2(n*2-1, 0),  # left
		func(n): return Vector2(n*2-1, -1),  # right
		func(n): return Vector2(-1, n*2-1)  # bottom
	]
	
	for cell_function in edge_data:
		var point = cell_function.call(randi_range(2, maze_size-3))
		maze[point.x][point.y] = 0
	
	# Remove center section
	@warning_ignore("integer_division")
	var half_size = len(maze) / 2
	for y in range(half_size-center_radius, half_size+center_radius+1):
		for x in range(half_size-center_radius, half_size+center_radius+1):
			maze[y][x] = 0
	
	# Get wall positions
	var wall_positions = []
	for y in range(2, len(maze)-2, 1):
		for x in range(2, len(maze)-2, 1):
			var wall_type = is_wall(maze, x, y)
			if wall_type != 0:
				wall_positions.append([y, x, wall_type])
	
	# Set dynamic walls
	wall_positions.shuffle()
	for pos in wall_positions.slice(0, amount_moving_walls):
		print(pos)
		maze[pos[0]][pos[1]] = pos[2]
	
	
# Works only with internal cells
func sum_neighbors(maze: Array, x: int, y: int) -> int:
	return maze[y-1][x] + maze[y+1][x] + maze[y][x-1] + maze[y][x+1]

func is_wall(maze: Array, x: int, y: int) -> int:
	if maze[y-1][x] and maze[y+1][x] and y % 2:
		return 2
	if maze[y][x-1] and maze[y][x+1] and x % 2:
		return 3
	return 0

func get_unvisited_neighbors(maze: Array, x: int, y: int) -> Array:
	var neighbors = []
	var directions = [Vector2(2, 0), Vector2(-2, 0), Vector2(0, 2), Vector2(0, -2)]
	
	for dir in directions:
		var nx = x + dir.x
		var ny = y + dir.y
		if nx > 0 and nx < maze_size * 2 and ny > 0 and ny < maze_size * 2 and maze[nx][ny] == 1:
			neighbors.append(Vector2(nx, ny))
	
	return neighbors

func rand_invert() -> int:
	return 1 - 2*randi_range(0, 1)

func create_maze_walls(maze: Array):
	for y in range(maze_size * 2 + 1):
		for x in range(maze_size * 2 + 1):
			var moving_wall_vector = Vector3.ZERO
			if maze[y][x] == 0:
				continue
			elif maze[y][x] == 2:
				moving_wall_vector = Vector3(1, 0, 0) * rand_invert()
			elif maze[y][x] == 3:
				moving_wall_vector = Vector3(0, 0, 1) * rand_invert()
			
			var wall_size = Vector3.ZERO
			var wall_position = Vector3.ZERO
			
			# Determine if it's a vertical or horizontal wall
			if y % 2 == 0 and x % 2 == 1:
				# Vertical wall
				wall_size = Vector3(wall_thickness, wall_height, cell_size + wall_thickness)
				@warning_ignore("integer_division")
				wall_position = Vector3((y / 2) * cell_size, wall_height / 2, (x / 2) * cell_size) + Vector3(0, 0, cell_size/2)
			elif y % 2 == 1 and x % 2 == 0:
				# Horizontal wall
				wall_size = Vector3(cell_size + wall_thickness, wall_height, wall_thickness)
				@warning_ignore("integer_division")
				wall_position = Vector3((y / 2) * cell_size, wall_height / 2, (x / 2) * cell_size) + Vector3(cell_size/2, 0, 0)
			elif (y == 0 or y == maze_size*2) and (x == 0 or x == maze_size*2):
				# Corner post
				wall_size = Vector3(wall_thickness, wall_height, wall_thickness)
				@warning_ignore("integer_division")
				wall_position = Vector3((y / 2) * cell_size, wall_height / 2, (x / 2) * cell_size)
			
			# Generate wall node
			var wall = StaticBody3D.new()
			if moving_wall_vector:
				wall.set_script(moving_wall_script)
				wall.moving_wall_vector = moving_wall_vector
			
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
			wall.set_collision_layer_value(3, true)
			wall.set_collision_mask_value(3, true)
			add_child(wall)
			walls.append(wall)

func clear_maze():
	for wall in walls:
		wall.queue_free()
	walls.clear()
