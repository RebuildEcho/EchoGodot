extends KinematicBody2D

export (int) var speed = 150
var moveSpeed
export (int) var jumpSpeed = -400
export (int) var gravity = 10
var running

var velocity = Vector2()
var airborne = false

func _ready():
	moveSpeed = speed
	running = false

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')

	if jump and is_on_floor():
		velocity.y = jumpSpeed
	if right:
		velocity.x += moveSpeed
	if left:
		velocity.x -= moveSpeed
		

func _physics_process(delta):
	get_input()
	velocity.y += gravity
	
	if is_on_floor():
		airborne = false
	else:
		airborne = true
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	
	
func _process(delta):
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	$AnimatedSprite.speed_scale = 1.5
	if airborne:
		moveSpeed = speed / 2
	else:
		moveSpeed = speed
	
	
	if airborne:
		$AnimatedSprite.play("Falling")
	else:
		if right:
			if !running:
				$AnimatedSprite.speed_scale = 0.5
				$AnimatedSprite.play("Run Start")
				$AnimatedSprite.flip_h = false
				running = true
			elif $AnimatedSprite.frame == 1:
				$AnimatedSprite.play("Run")
				$AnimatedSprite.flip_h = false
			
		if left:
			if !running:
				$AnimatedSprite.speed_scale = 0.5
				$AnimatedSprite.play("Run Start")
				$AnimatedSprite.flip_h = true
				running = true
			elif $AnimatedSprite.frame == 1:
				$AnimatedSprite.play("Run")
				$AnimatedSprite.flip_h = true
		
		if (!left && !right) || (left && right):
			$AnimatedSprite.speed_scale = 0.25
			$AnimatedSprite.play("Idle")
			running = false
		




