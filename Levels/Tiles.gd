extends TileMap

onready var astar = AStar2D.new()
onready var rect = get_used_rect()
var obstacle_cells = []
var walkable_cells = []


func _ready():
	set_obstacle_cells()
	set_walkable_cells()
	for cell in walkable_cells:
		if cell in obstacle_cells:
			print(cell)
	astar_fill_points()


func astar_fill_points():
	for point in walkable_cells:
		astar.add_point(calculate_point_id(point), point)
	
	for point in walkable_cells:
		var id = calculate_point_id(point)
		for y in range(3):
			for x in range(3):
				var neighbor_point = Vector2(point.x + x - 1, point.y + y - 1)
				var neighbor_id = calculate_point_id(neighbor_point)
				if point == neighbor_point or not astar.has_point(neighbor_id) or is_outside_rect(neighbor_point):
					continue
				astar.connect_points(id, neighbor_id, false)


func get_astar_path(world_start, world_end):
	var path = []
	var start_index = calculate_point_id(world_to_map(world_start))
	var end_index = calculate_point_id(world_to_map(world_end))
	
	for point in astar.get_point_path(start_index, end_index):
		path.append(map_to_world(point) + cell_size / 2)
	
	return path


func statme():
	print("Rect is ", rect.size.x, " by ", rect.size.y)


func calculate_point_id(point):
	return point.x + rect.size.x * point.y


func set_walkable_cells():
	walkable_cells = get_used_cells_by_id(3)


func set_obstacle_cells():
	for id in range(3):
		#obstacle_cells.append_array(get_used_cells_by_id(id))
		obstacle_cells = obstacle_cells + get_used_cells_by_id(id)


func is_outside_rect(point):
	return point.x < rect.position.x or point.y < rect.position.y or point.x >= rect.end.x or point.y >= rect.end.y

