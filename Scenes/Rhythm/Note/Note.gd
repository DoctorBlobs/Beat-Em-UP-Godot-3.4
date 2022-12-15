extends Area2D


export var WaitTime = 0.1;

export var Target_Y = 160
export var TARGET_X = 160
export var SPAWN_X = 320

var DIST_TO_TARGET = TARGET_X + SPAWN_X

var speed = 0
var hit = false

func _ready():
	pass


func _physics_process(delta):
	if !hit:
		position.x += speed * delta
		if position.x > TARGET_X + 5:
			queue_free()
			get_parent().reset_combo()
	else:
		$Node2D.position.y -= speed * delta


func initialize():
	position.y = 160
	speed = DIST_TO_TARGET / 2.0


func destroy(score):
	$CPUParticles2D.emitting = true
	$AnimatedSprite.visible = false
	$Timer.set_wait_time(WaitTime)
	$Timer.start()
	hit = true
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("c3a38a")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("997577")


func _on_Timer_timeout():
	queue_free()
