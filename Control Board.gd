extends StaticBody2D

signal repair_signal
onready var anim = get_node("AnimatedSprite")
var isPlayerInRange = false
var isNotRepaired = true

var soundPlayer2

func _ready():
	anim.animation = "default"
	soundPlayer2 = AudioStreamPlayer.new()
	self.add_child(soundPlayer2)
	soundPlayer2.stream = load("res://Sounds//gear_sound.wav")

func _process(delta):
	var repair = Input.is_action_pressed('ui_fire')
	if isPlayerInRange && repair && isNotRepaired:
		isNotRepaired = false
		anim.frame = 1
		soundPlayer2.play()
		emit_signal("repair_signal")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		isPlayerInRange = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		isPlayerInRange = false
