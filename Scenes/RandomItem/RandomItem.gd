extends Node2D

export var gravity = 10

export var ACCELERATION_MAX = 4000
export var MAX_SPEED_MAX = 25000
export var LIMIT_SPEED_Y_MAX = 1500
export var JUMP_HEIGHT_MAX = 30000
export var MIN_JUMP_HEIGHT_MAX = 10000
export var MAX_COYOTE_TIME_MAX = 6
export var JUMP_BUFFER_TIME_MAX = 10
export var WALL_JUMP_AMOUNT_MAX = 50000
export var WALL_JUMP_TIME_MAX = 10
export var WALL_SLIDE_FACTOR_MAX = 0.8
export var WALL_HORIZONTAL_TIME_MAX = 30
export var GRAVITY_MAX = 500
export var DASH_SPEED_MAX = 42500

export var  ACCELERATION_MIN = 4000
export var  MAX_SPEED_MIN = 25000
export var  LIMIT_SPEED_Y_MIN = 1500
export var  JUMP_HEIGHT_MIN = 30000
export var  JUMP_BUFFER_TIME_MIN = 10
export var  GRAVITY_MIN = 500
export var  DASH_SPEED_MIN = 42500

func _physics_process(_delta):
	velocity.y += gravity

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var Player = area.shape_owner_get_owner(area_shape_index)
	var MinMax = ['_MIN', '_MAX']
	var Function = ['ACCELERATION', 'MAX_SPEED', 'LIMIT_SPEED_Y', 'JUMP_HEIGHT', 'JUMP_BUFFER_TIME', 'GRAVITY', 'DASH_SPEED']
	
	var Variable:int = randi() % Function.size()
	var MinorMax:int = randi() % MinMax.size()
	
	var VarAmount = Variable + MinMax
	
	Player.Variable = VarAmount
	
