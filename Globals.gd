extends Node

var soundPlayer
var soundPlayer2

func _ready():
	soundPlayer = AudioStreamPlayer.new()
	self.add_child(soundPlayer)
	soundPlayer.stream = load("res://Sounds//horn.ogg")
	
	soundPlayer2 = AudioStreamPlayer.new()
	self.add_child(soundPlayer2)
	soundPlayer2.stream = load("res://Sounds//rain_and_thunder.wav")
