extends Control

func _ready():
	$btn_continue.connect("pressed", self, "Continue")
	$btn_options.connect("pressed", self, "Options")
	$btn_main_menu.connect("pressed", self, "MainMenu")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().paused = not get_tree().paused
			visible = not visible

func Continue():
	visible = not visible
	get_tree().paused = not get_tree().paused

func Options():
	pass
	
func MainMenu():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://MainMenu.tscn")
