extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$btn_main_menu.connect("pressed", self, "MainMenu")
	$btn_options.connect("pressed", self, "Options")

func MainMenu():
	get_tree().change_scene("res://MainMenu.tscn")

func Options():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://GameMenu.tscn")
			get_tree().set_pause(false)
