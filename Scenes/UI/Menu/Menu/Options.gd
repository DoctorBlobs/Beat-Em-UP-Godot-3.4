extends Control

var scene_path_to_load
var Soundon = true

func _ready():
	set_process(true)

	
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		$FadeIn.show()
		$FadeIn.fade_in()

func _on_Back_Button_button_down():
	$UISound.play()
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/UI/Menu/Menu/Main Menu.tscn")

func _on_Sound_Button_button_down():
	if Soundon:
		AudioServer.set_bus_mute(1, true)
		$HBoxContainer/VBoxContainer2/Sound_Button/Label.text = "Sound (Off)"
	else:
		AudioServer.set_bus_mute(1, false)
		$HBoxContainer/VBoxContainer2/Sound_Button/Label.text = "Sound (On)"



	pass # Replace with function body.
