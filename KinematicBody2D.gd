extends KinematicBody2D

onready var path = $".."/Path2D
var points
var index = 0
var velocity = Vector2()

func _ready():
	points = path.curve.get_baked_points()

func _physics_process(delta):
	var target = points[index]
	if position.distance_to(target) < 1:
		index += 1
		target = points[index]
	
	velocity = (target - position).normalized() * 100
	velocity = move_and_slide(velocity)
