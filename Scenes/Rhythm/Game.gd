extends Node2D

var score = 0
var combo = 0

var songend = 0

var sound_has_played = false

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

export var notesabountindex = 1
export var notesamount = 1

var bpm = 115

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var lane = 0
var rand = 0
var note = load("res://Scenes/Rhythm/Note/Note.tscn")
var instance


func _ready():
	songend = $Conductor.bpm * $Conductor.stream.get_length()
	
	randomize()

	$Conductor.play_with_beat_offset(2)
	
func _on_Conductor_measure(position):
	pass
	
func _on_Conductor_beat(position):
	
	$Metronome.play()
	
	song_position_in_beats = position
	
	_spawn_notes(1)
	
	if song_position_in_beats > songend:
		Global.set_score(score)
		Global.combo = max_combo
		Global.great = great
		Global.good = good
		Global.okay = okay
		Global.missed = missed
		if get_tree().change_scene("res://Scenes/Rhythm/End/End.tscn") != OK:
			print ("Error changing scene to End")



func _spawn_notes(to_spawn):
	instance = note.instance()
	instance.initialize()
	add_child(instance)


func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
	$Label.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""


func reset_combo():
	combo = 0
	$Combo.text = ""
