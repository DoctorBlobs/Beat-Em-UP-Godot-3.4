extends KinematicBody2D

#Base Stats
export var  ACCELERATION = 4000
export var  MAX_SPEED = 25000
export var  LIMIT_SPEED_Y = 1500
export var  JUMP_HEIGHT = 30000
export var  MIN_JUMP_HEIGHT = 10000
export var  MAX_COYOTE_TIME = 6
export var  JUMP_BUFFER_TIME = 10
export var  WALL_JUMP_AMOUNT = 50000
export var  WALL_JUMP_TIME = 10
export var  WALL_SLIDE_FACTOR = 0.8
export var  WALL_HORIZONTAL_TIME = 30
export var  GRAVITY = 500
export var  DASH_SPEED = 42500

var Spawn = Vector2()
var velocity = Vector2()
var axis = Vector2()

var coyoteTimer = 0
var jumpBufferTimer = 0
var wallJumpTimer = 0
var wallHorizontalTimer = 0
var dashTime = 0

#True and False Statements
var CanAttack = true
var canJump = false
var friction = false
var wall_sliding = false
var trail = false
var isDashing = false
var hasDashed = false
var isGrabbing = false
var RespawnDone = false

#Enable and Disable Ability's
export var GrabAbility = false
export var DashAbility = false
export var DoubleJump = false
export var WallJumpAbility = false

export var PhaseTime = 0.25
export var DashCooldown = 5
export var Knockback = 1

#Used to keep the Health in one INT
export var Health = 5
export var HealthDepleted = false

#Attack Variables
export var attack_cooldown_time = 1000
var next_attack_time = 0
export var attack_damage = 30

#Used for Multiple Players & Input Names
export var PlayerIndex = 1
export var KeyboardTrue = true
export var  Keyboard = " (Keyboard)"

var JumpButton = "Jump Player " + PlayerIndex as String
var DashButton = "Dash Player " + PlayerIndex as String
#var PhaseButton = "Phase Player " + PlayerIndex as String
var AttackButton = "Attack Player " + PlayerIndex as String
var GrabButton = "Grab Player " + PlayerIndex as String 
var RightButton = "Right Player " + PlayerIndex as String 
var LeftButton = "Left Player " + PlayerIndex as String
var UpButton = "Up Player " + PlayerIndex as String
var DownButton = "Down Player " + PlayerIndex as String

#Initalize Objects and Nodes
onready var anim = $AnimationPlayer
onready var HealthBar = $HealthBar

#signals
signal Killed
signal Player1Win
signal Player2Win
signal Player3Win
signal Player4Win


func _ready():
	add_to_group("Player" + PlayerIndex as String)
	
	#If Keyboard is selected then keyboard bindings used
	if KeyboardTrue:
		JumpButton = "Jump Player " + PlayerIndex as String + Keyboard
		DashButton = "Dash Player " + PlayerIndex as String + Keyboard
		AttackButton = "Attack Player " + PlayerIndex as String + Keyboard
		#PhaseButton = "Phase Player " + PlayerIndex as String + Keyboard
		GrabButton = "Grab Player " + PlayerIndex as String + Keyboard
		RightButton = "Right Player " + PlayerIndex as String + Keyboard
		LeftButton = "Left Player " + PlayerIndex as String + Keyboard
		UpButton = "Up Player " + PlayerIndex as String + Keyboard
		DownButton = "Down Player " + PlayerIndex as String + Keyboard
	
	#Health is the Health var
	HealthBar.ready(Health)
	anim.play_backwards("Death")
	Spawn = self.get_position()
	
	#set icons
	PlayerIcons()
	
	#set Colissions
	print(HealthBar)
		
	#Get Spawn
	Spawn = self.position

func _process(delta):
	if HealthDepleted == true:
		#Disable everything
		CanAttack = false
		canJump = false
		friction = false
		wall_sliding = false
		trail = false
		isDashing = false
		hasDashed = false
		isGrabbing = false
		
		#Velocity and Raycast Detection
		velocity.y = 0
		velocity.x = 0
		axis.y = 0
		axis.x = 0
		velocity = Vector2.ZERO
		$Rotatable/RayCast2D.enabled = false
		
		#Set Self Visible Flase
		$Colission.disabled = true
		self.visible = false
		
		#Kill()
		
		#Respawn Stuff
		#if RespawnDone == false:
		#	Respawn()

func _physics_process(delta):
	if velocity.y <= LIMIT_SPEED_Y:
		if !isDashing:
			velocity.y += GRAVITY * delta
	
	friction = false
	
#	Attack()
	Attack(delta)
	getInputAxis()
	dash(delta)
	RaycastMove()
	wallSlide(delta)

	#basic vertical movement mechanics
	if wallJumpTimer > WALL_JUMP_TIME:
		wallJumpTimer = WALL_JUMP_AMOUNT
		if !isDashing && !isGrabbing:
			horizontalMovement(delta)
	else:
		wallJumpTimer += 1
	
	if !canJump:
		if !wall_sliding:
			if velocity.y >= 0:
				anim.play(str("Fall"))
			elif velocity.y < 0:
				anim.play(str("Jump"))

	#jumping mechanics and coyote time
	if is_on_floor():
		canJump = true
		coyoteTimer = 0
	else:
		coyoteTimer += 1
		if coyoteTimer > MAX_COYOTE_TIME:
			canJump = false
			coyoteTimer = 0
		friction = true
	
	jumpBuffer(delta)

	if Input.is_action_pressed(JumpButton):
		if canJump:
			jump(delta)
			frictionOnAir()
		else:
			if WallJumpAbility:
				if $Rotatable/RayCast2D.is_colliding():
					wallJump(delta)
			frictionOnAir()
			jumpBufferTimer = JUMP_BUFFER_TIME #amount of frame

	setJumpHeight(delta)
	jumpBuffer(delta)

	velocity = move_and_slide(velocity, Vector2.UP)

func jump(delta):
	velocity.y = -JUMP_HEIGHT * delta



func wallJump(delta):
	wallJumpTimer = 0
	velocity.x = -WALL_JUMP_AMOUNT * $Rotatable.scale.x * delta
	velocity.y = -JUMP_HEIGHT * delta
	$Rotatable.scale.x = -$Rotatable.scale.x



func wallSlide(delta):
	if !canJump:
		if $Rotatable/RayCast2D.is_colliding():
			wall_sliding = true
			if GrabAbility:
				if Input.is_action_pressed(GrabButton):
					isGrabbing = true
					if axis.y != 0:
						velocity.y = axis.y * 12000 * delta
						anim.play(str("Climb"))
					else:
						velocity.y = 0
						anim.play(str("Wall Slide"))
				else:
					isGrabbing = false
					velocity.y = velocity.y * WALL_SLIDE_FACTOR
					anim.play(str("Wall Slide"))
		else:
			wall_sliding = false
			isGrabbing = false

func Push(delta):
	if $Rotatable/Combat/AttackDetection.is_colliding():
		var targetcol = $Rotatable/Combat/AttackDetection.get_collider()
		if targetcol != null:
			var target = targetcol.get_owner()
			target.move_and_collide(Vector2(-1, 0))



func frictionOnAir():
	if friction:
		velocity.x = lerp(velocity.x, 0, 0.01)



func jumpBuffer(delta):
	if jumpBufferTimer > 0:
		if is_on_floor():
			jump(delta)
		jumpBufferTimer -= 1



func setJumpHeight(delta):
	if Input.is_action_just_released(UpButton):
		if velocity.y < -MIN_JUMP_HEIGHT * delta:
			velocity.y = -MIN_JUMP_HEIGHT * delta



func horizontalMovement(delta):
	if Input.is_action_pressed(RightButton):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				anim.play(str("Run"))
		else:
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				anim.play(str("Run"))

	elif Input.is_action_pressed(LeftButton):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				anim.play(str("Run"))
		else:
			velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				anim.play(str("Run"))
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
		if canJump:
			anim.play(str("Idle"))

func dash(delta):
	if DashAbility:
		if !hasDashed:
			if Input.is_action_pressed(DashButton):
				velocity = axis * DASH_SPEED * delta
				Input.start_joy_vibration(0, 1, 1, 0.2)
				isDashing = true
				hasDashed = true
				
				
				#$ShakeCamera2D/AnimationPlayer.play("Shake 1 (Pretty Heavy)")
				
				
#				$Rotatable/Combat/Area2D.monitorable = false
#				$Colission.disabled = true
#				var timer = $Timers/PhaseTimer
#				timer.wait_time = PhaseTime
#				timer.start() 
				
				var Dashtimer = $Timers/DashCooldown
				Dashtimer.wait_time = DashCooldown
				Dashtimer.start() 
				
		if isDashing:
			trail = true
			dashTime += 1
			if dashTime >= int(0.25 * 1 / delta):
				isDashing = false
				trail = false
				dashTime = 0
		if is_on_floor() && velocity.y >= 0:
			hasDashed = false
	else:
		return

func _on_PhaseTimer_timeout():
	$Rotatable/Combat/Area2D.monitorable = true
	$Colission.disabled = false

func _on_DashCooldown_timeout():
	hasDashed = false

func Modification(Variable, Amount):
	Variable = Amount
	var timer = $Timers/ModCooldown
	timer.start() 
	

func _on_ModCooldown_timeout():
	pass # Replace with function body.

func _on_trailTimer_timeout():
	if trail:
		var trail_sprite = Sprite.new()
		trail_sprite.texture = load("res://assets/sprites/playerSprites.png")
		trail_sprite.vframes = 10
		trail_sprite.hframes = 8
		trail_sprite.frame = $Rotatable/Sprite.frame
		trail_sprite.scale.x = 2 * 1.2
		trail_sprite.scale.y = 2 * 1.2
		trail_sprite.scale.x = $Rotatable.scale.x * 2 * 1.2
		trail_sprite.set_script(load("res://assets/scripts/trail_fade.gd"))
		
		get_parent().add_child(trail_sprite)
		trail_sprite.position = position
		trail_sprite.modulate = Color( 1, 0.08, 0.58, 0.5 )
		trail_sprite.z_index = -49

func getInputAxis():
	axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed(RightButton)) - int(Input.is_action_pressed(LeftButton))
	axis.y = int(Input.is_action_pressed(DownButton)) - int(Input.is_action_pressed(UpButton))
	axis = axis.normalized()


#Health System
func TakeDamage(AttackDamage, delta, dir):
	#KnockBack
	KnockBack(delta, dir)
	#Set AttackDamage as the Var
	AttackDamage = attack_damage
	#Remove and print Health
	Health = Health - AttackDamage
	HealthBar.ReduceHealth(AttackDamage)
	print(Health)
	#Play the Animation
	anim.play("TakeDamage")

#func Phasing():
#	if Input.is_action_pressed(PhaseButton):
#		$Rotatable/Combat/Area2D.monitorable = false
#		$Colission.disabled = true
#		var timer = $Timers/PhaseTimer
#		timer.start() 

func _on_HealthBar_health_depleted():
	#HealthDepleted is True
	HealthDepleted = true
	emit_signal("Killed")
	print("lol")

func Kill():
	emit_signal("Killed")
	print("lol")

func Respawn():
	self.visible = false
	var timer = $Timers/RespawnTimer
	timer.start() 

func _on_RespawnTimer_timeout():
	print("respawn")
	HealthBar.Respawn()
	HealthBar.ready(Health)
	HealthBar.ping()
	self.visible = true
	self.position = Spawn
	RespawnDone = true

func KnockBack(delta, dir):
	velocity.x = dir * Knockback * delta
	velocity = move_and_slide(velocity)


func RaycastMove():
	var Raycast = $Rotatable/Combat/AttackDetection
	var Rotation = -90
	
	if Input.is_action_pressed(UpButton):
		Raycast.set_rotation(Rotation + 30)
	elif Input.is_action_pressed(DownButton):
		Raycast.set_rotation(Rotation - 30)
	else:
		Raycast.set_rotation(Rotation)

func PlayerIcons():
	pass
	#var PlayerID  = ("Player " + PlayerIndex as String)
	
	#var path = load("res://Assets/UI/Player Icons/ " + PlayerID + ".png")
	#$PlayerIcon.texture = path
	
#Attack System
func Attack(delta):
	if Input.is_action_pressed(AttackButton):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
#			# What's the target?
			var targetcol = $Rotatable/Combat/AttackDetection.get_collider()
#			#Play the Animation
			anim.play("Attack")
#			#Check Target
			if targetcol != null:
				var target = targetcol.get_owner()
				var tagetHealth = target.HealthBar
				var dir = $Rotatable.scale.x
				tagetHealth.ping()
				target.TakeDamage(attack_damage, delta, dir)
				print("Damage Taken")
			elif targetcol == null:
				print("Miss")
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time

func _on_player_1_Killed():
	emit_signal("Player1Win")
func _on_player_2_Killed():
	emit_signal("Player2Win")
func _on_player_3_Killed():
	emit_signal("Player3Win")
func _on_player_4_Killed():
	emit_signal("Player4Win")
