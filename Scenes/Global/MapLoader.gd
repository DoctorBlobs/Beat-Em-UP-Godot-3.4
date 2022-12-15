extends Node


export var loadmod = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if loadmod:
		ModLoad()
	else:
		return

#Receive a text and compress it, then encode to base 64
func ModLoad():
	ProjectSettings.load_resource_pack("res://mod.pck")
	# Now you can use the assets as if you had them in the project from the start
	var imported_scene = load("res://modScene.tscn")
