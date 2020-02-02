extends Node

var soundPlayer

func _ready():
	soundPlayer = AudioStreamPlayer.new()
	self.add_child(soundPlayer)
	soundPlayer.stream = load("res://Sounds//horn.ogg")

