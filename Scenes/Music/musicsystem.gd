extends AudioStreamPlayer
# Exports
export(Array, AudioStream) var SoundList
export var ImmediatelyPlay : bool = true
export var TimeBetweenTracks : float = 1.00
export var KeepPlaying : bool = true
# Best not to edit these, unless you know what you are doing.
var sounds = 0
var soundtoplay = 0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	sounds = SoundList.size()
	$TimeBetweenTracks.wait_time = TimeBetweenTracks
	sounds -= 1
	print("Songs:", sounds)
	match ImmediatelyPlay:
		true:
			playsong()
		false:
			pass

func playsong():
	soundtoplay = rng.randi_range(0, sounds)
	print(soundtoplay)
	$".".stream = SoundList[soundtoplay]
	$".".play()

func _on_Music_System_finished():
	match KeepPlaying:
		true:
			$TimeBetweenTracks.start()
		false:
			pass

func _on_TimeBetweenTracks_timeout():
	playsong()
