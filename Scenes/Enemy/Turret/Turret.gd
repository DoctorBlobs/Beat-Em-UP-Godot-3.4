extends Area2D

var Missile = load("res://Scenes/Enemy/Missle/Missile.tscn")

export var rotation_speed = PI
export var cooldown = 0.5

var target = null
var can_shoot = true

func shoot():
	if can_shoot:
		var m = Missile.instance()
		get_parent().add_child(m)
		m.start($Turret/Muzzle.global_transform, target)
		flash()
		can_shoot = false
		yield(get_tree().create_timer(cooldown), "timeout")
		can_shoot = true

func flash():
	$Turret/Flash.show()
	yield(get_tree().create_timer(0.1), "timeout")
	$Turret/Flash.hide()
	
func find_target():
	var units = get_overlapping_bodies()

	var CurrentRotation = $RayCast2D.get_rotation_degrees()

	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit
		target = closest
	else:
		target = null
			
func _process(delta):
	if !target:
		find_target()
	if target:
		$Turret.look_at(target.global_position)
		shoot()
		
func _on_Launcher_body_exited(body):
	if body == target:
		target = null
