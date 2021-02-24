extends KinematicBody2D

var points = []
var index = 0
var move_speed = 100

onready var body_radius = $CollisionShape2D.shape.radius

var line

func _ready():
	var arr = []
	print(arr.front())
	pass

func _physics_process(delta):
	move_along(delta)
	return
	if !points:
		return
	var target = points[index]
	if position.distance_to(target) < 1:
		index += 1
		if index >= points.size():
			index = 0
			points = null
			return
		
	var velocity = (target - position).normalized() * move_speed
	draw_velocity(velocity)
	#print(position, velocity * delta)
	velocity = move_and_slide(velocity)
	if get_slide_count() > 0:
		velocity = move_and_slide(velocity)


func go(fp):
	line = Line2D.new()
	line.width = 2
	line.default_color = Color(1,0,0)
	add_child(line)
	points = Array(fp)


func draw_velocity(velocity):
	line.clear_points()
	line.add_point(Vector2())
	line.add_point(velocity)


func move_along(delta):
	var point = get_point()
	if !point: return
	if position.distance_to(point) < 1:
		next_point()
		return
	
	var velocity = (point - position).normalized() * move_speed
#	draw_velocity(velocity)
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		print("poi: ", point, " pos: ", position, " nor: ", collision.normal, " col: ", collision.position, " dis: ", position.distance_to(point))

		# https://docs.godotengine.org/en/stable/tutorials/math/vectors_advanced.html#doc-vectors-advanced
		# Distance from the Origin to the collision Plane
		var D = collision.normal.dot(collision.position)
		# distance from Point to Plane
		var ptp = collision.normal.dot(point) - D
		# Offset - how far to move Point from the Plane:
		# distance from Body center to Plane minus distance from Point to Plane
		var offset = position.distance_to(collision.position) - ptp
		var offset_vector = collision.normal * (offset + 0.1)
		var new_point = offset_vector + point

		if ptp > 0:
			next_point(new_point)
		else:
			add_intermediate_point(new_point)
		draw_velocity(new_point - position)
		print("new: ", new_point, " off: ", offset, " dis: ", position.distance_to(new_point), " ptp: ", ptp, " ov: ", offset_vector)
		print(collision.normal.ceil(), collision.normal.floor(), collision.normal.round())
		print("---")
		#breakpoint


func get_point():
	if !points or points.empty(): return null
	return points.front()


func next_point(point = null):
	if point:
		points[0] = point
	else:
		points.pop_front()


func add_intermediate_point(point):
	points.push_front(point)


