extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().set_pause(true)
			$Player.get_child(0).get_child(1).visible = true
			$Player.get_child(0).get_child(1).get_child(2).connect("pressed", self, "Continue")
			$Player.get_child(0).get_child(1).get_child(3).connect("pressed", self, "Options")
			$Player.get_child(0).get_child(1).get_child(4).connect("pressed", self, "MainMenu")

func Continue():
	$Player.get_child(0).get_child(1).visible = false
	get_tree().set_pause(false)

func Options():
	pass
	
func MainMenu():
	get_tree().change_scene("res://MainMenu.tscn")

