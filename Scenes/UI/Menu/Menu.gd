extends Control

export var startscenepath = "res://Scenes/Levels/Main.tscn"
export var tutorialscenepath ="res://Scenes/Levels/Tutorial/Tutorial.tscn"
export var optionsscenepath = "res://Scenes/UI/Menu/Menu/Options.tscn"

var score_file = "user://Game.save"	

#func save_to_file():
#	var file = File.new()
#	file.open(score_file, File.WRITE)
#	file.store_var(c, true)
#	file.close()


#func load_from_file():
#	var file = File.new()
#	if file.file_exists(score_file):
#		file.open(score_file, File.READ)
#		c = file.get_var(true)
#		file.close()

func _ready():
	set_process(true)
	$FadeIn.show()
	$FadeIn.fade_in()
	
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		$FadeIn.show()
		$FadeIn.fade_in()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$Settings.set_visible(false) 
		$MainMenu.set_visible(true) 

func _on_Start_Button_button_down():
	if get_tree().change_scene(startscenepath) != OK:
		print ("Error changing scene to Game")

func _on_Tutorial_Button_button_down():
	if get_tree().change_scene(tutorialscenepath) != OK:
		print ("Error changing scene to Game")

func _on_Quit_Button_button_down():
	get_tree().quit()

func HideMenu():
	$MainMenu.visible(false)

func _on_TextureButton_pressed():
	$TextureButton/AudioStreamPlayer.play()



func _on_Options_Button_button_down():
	get_tree().change_scene(optionsscenepath)
