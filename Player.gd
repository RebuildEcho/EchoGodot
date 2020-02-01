extends KinematicBody2D

export (int) var speed = 300
export (int) var jumpSpeed = -1200
export (int) var gravity = 20

var velocity = Vector2()
var airborne = false

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')

	if jump and is_on_floor():
		airborne = true
		velocity.y = jumpSpeed
	if right:
		velocity.x += speed
	if left:
		velocity.x -= speed

func _physics_process(delta):
	get_input()
	#velocity.y += gravity * delta
	if airborne and is_on_floor():
		airborne = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	
	
func _process(delta):
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	
	if right:
		$AnimatedSprite.play("Run")
		$AnimatedSprite.flip_h = false
	if left:
		$AnimatedSprite.play("Run")
		$AnimatedSprite.flip_h = true
	
	if !left && !right:
		$AnimatedSprite.play("Idle")
		




