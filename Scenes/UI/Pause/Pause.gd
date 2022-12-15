extends Control

export var MenuScenePath = "res://Scenes/UI/Menu/Menu.tscn"

onready var MainMenu = get_node("MainMenu")
onready var SettingsMenu = get_node("Settings")

func _ready():
	get_tree().paused = false
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if MainMenu.visible == false:
			$MainMenu.set_visible(true)
			$Background.set_visible(true)
			#$Settings.set_visible(false)
			get_tree().paused = true
		elif SettingsMenu.visible == true && MainMenu.visible == false:
			$MainMenu.set_visible(true)
			$Background.set_visible(true)
			#$Settings.set_visible(false)
			get_tree().paused = true
		elif MainMenu.visible == true:
			$MainMenu.set_visible(false)
			$Background.set_visible(false)
			#$Settings.set_visible(false)
			get_tree().paused = false
		
func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/UI/Menu/Menu.tscn")
	get_tree().paused = false
	set_visible(false)
	

func _on_Settings_pressed():
		$MainMenu.visible = !$MainMenu.visible
		$Settings.visible = !$Settings.visible
	
func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)
	
func _on_Exit_pressed():
	get_tree().quit()
	
func HideMenu():
	$MainMenu.visible(false)

func set_visible(visible):
	for node in get_children():
		node.visible = visible


func _on_Settings_MenuHide():
	set_visible(true)


func _on_Reload_pressed():
	get_tree().reload_current_scene()
