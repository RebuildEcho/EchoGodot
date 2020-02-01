extends Control

var a = 0
var start_count = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$btn_play.connect("pressed", self, "Play")
	$btn_options.connect("pressed", self, "Options")
	$btn_exit.connect("pressed", self, "Exit")

func Play():
	start_count = true

func Options():
	pass
	
func Exit():
	get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(start_count):
		a = a + delta
	if(a > 1.5):
		get_tree().change_scene("res://Game.tscn")
