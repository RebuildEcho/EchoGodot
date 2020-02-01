extends KinematicBody2D

export (int) var speed = 400
export (int) var jumpSpeed = -400
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
	
func _process(delta):
	if velocity == Vector2(0,0):
		$AnimatedSprite.speed_scale = 0.25
		$AnimatedSprite.play("menuIdle")
	else:
		$AnimatedSprite.speed_scale = 1.5
		$AnimatedSprite.play("menuRun")

func _on_btn_play_pressed():
	velocity.x += speed
	
