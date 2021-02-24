extends Node

onready var PawnPath = preload("res://Levels/PawnPath.tscn")
var line

func _input(event):
	if event is InputEventMouseButton and event.get_button_index() == BUTTON_LEFT and event.is_pressed():
		var last_point = line.get_point_position(line.get_point_count() - 1)
		print("Mouse Click/Unclick at: ", event.position)
		for point in $Tiles.get_astar_path(last_point, event.position):
			line.add_point(point)
	elif event.is_action_pressed("ui_select"):
		execute_plan()


func _ready():
	line = PawnPath.instance()
	var pawns = get_tree().get_nodes_in_group("assaulter")
	line.add_point(pawns[0].position)
	add_child(line)
	$Tiles.statme()


func execute_plan():
	var pawns = get_tree().get_nodes_in_group("assaulter")
	#$Test.call("go", line.get_points())
	#$Test.go(line.get_points())
	for p in pawns:
		var points = line.get_points()
		#line.clear_points()
		p.go(points)
		#$Test.call("gogo", line.get_points())
