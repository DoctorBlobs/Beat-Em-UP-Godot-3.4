 extends KinematicBody2D

export var max_max_distance = 100
export var max_distance = 50
export var min_distance = 45
export var speed = 250
var velocity = Vector2.ZERO
var is_idle = false

func _physics_process(delta):
	var distance_from_player = global_position.distance_to(Global.player_position)
	
	if distance_from_player <= min_distance:
		global_position = global_position + Vector2(0,-1)
		velocity = 0
	
	if distance_from_player >= max_max_distance:
		velocity = 0
	
	if distance_from_player > min_distance and not is_idle:
		velocity = global_position.direction_to(Global.player_position) * speed
		velocity = move_and_slide(velocity)
		
	if distance_from_player <= min_distance:
		is_idle = true
		velocity = Vector2.ZERO
	elif distance_from_player >= max_distance:
		is_idle = false
	
	if velocity.x < 0:
		$Sprite.scale = Vector2(-1, 1)
	elif velocity.x > 1:
		$Sprite.scale = Vector2(1, 1)
		
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Idle")
