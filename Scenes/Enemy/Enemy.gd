extends KinematicBody2D

export (NodePath) var target

func _process(delta):
	if target:
		global_position = get_node(target).global_position
