extends Panel

signal health_depleted

onready var Chunks = $Chunks
onready var Chunk = preload("Chunk.tscn")
onready var Timer = $Timer

export var yaxis = 0

# Called when the node enters the scene tree for the first time.
func ready(health):
	hide()
	
	rect_size.x = health * 3 + 3
	rect_size.y = 6
	
	rect_position.x = -(health * 3 + 3)
	rect_position.y = yaxis
	
	for i in health:
			var c = Chunk.instance()
			Chunks.add_child(c) 

func ping():
	show()
	Timer.start()

func _on_Timer_timeout():
	hide()
	
func Respawn():
	var health_current = Chunks.get_children()
	var health_new = health_current.size() - health_current.size()
	var _CurrentChunk = Chunks.get_child(0)
	
	for i in range(health_current.size() - 1, health_new -1, -1):
		if i >= 0:
			health_current[i].queue_free()
			
func ReduceHealth(damage):
	ping()
	
	var health_current = Chunks.get_children()
	var health_new = health_current.size() - damage
	var _CurrentChunk = Chunks.get_child(0)

	
	for i in range(health_current.size() - 1, health_new -1, -1):
		if i >= 0:
			health_current[i].queue_free()
		if i <= 0:
			emit_signal("health_depleted")
			health_current = 0
			
