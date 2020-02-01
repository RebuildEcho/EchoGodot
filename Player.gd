extends KinematicBody2D

export (int) var speed = 200
var moveSpeed
export (int) var jumpSpeed = -400
export (int) var bounceSpeed = -400
export (float) var gravity = 100

var running
var wallJumpEnable
var fallFlag


var bounceDir
var velocity = Vector2()
var vSpeed = 0
var airborne = false
var jumping = false

func _ready():
	moveSpeed = speed
	bounceDir = 0
	running = false
	fallFlag = false
	wallJumpEnable = false

func get_input():
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	var bounce = Input.is_action_just_pressed('ui_bounce')


	if jump and is_on_floor():
		velocity.y += jumpSpeed
		jumping = true
	if right:
		velocity.x += moveSpeed
	if left:
		velocity.x -= moveSpeed
		
	if bounce && wallJumpEnable:
		#velocity.x += bounceSpeed * bounceDir * 12
		velocity.y += bounceSpeed
		wallJumpEnable = false
	
		

func _physics_process(delta):
	
	
#	if airborne:
#		if velocity.x > 0:
#			velocity.x -= speed / 2
#		if velocity.x < 0:
#			velocity.x += speed / 2
#	else:

		
	velocity.x = 0
	get_input()
	
	if jumping || !is_on_floor():
		velocity.y += gravity / 10
	else:
		velocity.y += gravity
		
	if velocity.y > 0:
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	print(velocity)
	
	
func _process(delta):
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	$AnimatedSprite.speed_scale = 1.5
	if airborne:
		moveSpeed = speed 
	else:
		moveSpeed = speed
	
	
	if !is_on_floor():
		airborne = true
		if !fallFlag:
			$AnimatedSprite.play("Fall Start")
			fallFlag = true
		elif $AnimatedSprite.frame > 0:
			$AnimatedSprite.play("Fall")
			
		if right:
			$AnimatedSprite.flip_h = false
		if left:
			$AnimatedSprite.flip_h = true
		
	else:
		airborne = false
		if $AnimatedSprite.animation == "Fall":
			$AnimatedSprite.animation = "Run Start"
		fallFlag = false
		if right:
			$AnimatedSprite.flip_h = false
			if !running:
				$AnimatedSprite.speed_scale = 0.2
				$AnimatedSprite.play("Run Start")
				running = true
			elif $AnimatedSprite.frame == 1:
				$AnimatedSprite.play("Run")
			
		if left:
			$AnimatedSprite.flip_h = true
			if !running:
				$AnimatedSprite.speed_scale = 0.2
				$AnimatedSprite.play("Run Start")
				running = true
			elif $AnimatedSprite.frame == 1:
				$AnimatedSprite.play("Run")
		
		if (!left && !right) || (left && right):
			$AnimatedSprite.speed_scale = 0.25
			$AnimatedSprite.play("Idle")
			running = false
		

func _on_wallJump_Collider_L_body_entered(body):
	wallJumpEnable = true
	bounceDir = 1
	print("Left")

func _on_wallJump_Collider_R_body_entered(body):
	wallJumpEnable = true
	bounceDir = -1
	print("Right")
