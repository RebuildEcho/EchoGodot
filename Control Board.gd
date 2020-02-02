extends StaticBody2D

signal repair_signal
onready var anim = get_node("AnimatedSprite")
var isPlayerInRange = false

func _ready():
	anim.animation = "default"

func _process(delta):
	var repair = Input.is_action_pressed('ui_fire')
	if isPlayerInRange && repair:
		anim.frame = 1
		emit_signal("repair_signal")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		isPlayerInRange = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		isPlayerInRange = false
