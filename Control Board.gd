extends StaticBody2D

var isPlayerInRange = false

func _ready():
	pass

func _process(delta):
	var repair = Input.is_action_pressed('ui_fire')
	if isPlayerInRange && repair:
		print("player repaired!")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		isPlayerInRange = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		isPlayerInRange = false
