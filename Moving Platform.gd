extends Node2D

const IDLE = 0.5

export (String) var source

export (bool) var active = false
var moveTo
export (int) var dist
export (bool) var vertical
export var speed = 3.0

onready var platform = $Platform
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node(source).connect(str("repair_signal"), self, "on_repaired")
	vertical = false
	moveTo = Vector2.RIGHT * dist

func _process(delta):
	if active:
		_init_platform()
		active = false
	
	if vertical:
		moveTo = Vector2.UP * dist
		

func _init_platform():
	var duration = moveTo.length() / float(speed * 32) # Literal value is tile size
	tween.interpolate_property(platform, "position", Vector2.ZERO, moveTo, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE)
	tween.interpolate_property(platform, "position",  moveTo, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE * 2)
	tween.start()


func on_repaired():
	active = !active


func _on_Tween_tween_all_completed():
	_init_platform()
