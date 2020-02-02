extends KinematicBody2D

export (int) var speed = 200
var moveSpeed
export (int) var jumpSpeed = -400
export (int) var bounceSpeed = -400
export (float) var gravity = 100

var running
var wallJumpEnable
var fallFlag
var pitchFlag = false

var right_rel = false
var left_rel = false
var jump_rel = false

var dying = false
var bounceDir
var velocity = Vector2()
var vSpeed = 0
var airborne = false
var jumping = false
var interacting = false
var inLocked
var using
var dead

var soundPlayer

func _ready():
	moveSpeed = speed
	bounceDir = 0
	running = false
	fallFlag = false
	wallJumpEnable = false
	inLocked = false
	using = false
	dead = false
	
	soundPlayer = AudioStreamPlayer.new()
	self.add_child(soundPlayer)
	soundPlayer.stream = load("res://Sounds//walk.wav")

func get_input():
	
	var right = Input.is_action_pressed('ui_right')
	if Input.is_action_just_released('ui_right'):
		right_rel = true
	var left = Input.is_action_pressed('ui_left')
	if Input.is_action_just_released('ui_left'):
		left_rel = true
	var jump = Input.is_action_just_pressed('ui_jump')
	if Input.is_action_just_released('ui_jump'):
		jump_rel = true
	var bounce = Input.is_action_just_pressed('ui_bounce')
	var interact = Input.is_action_just_pressed('ui_fire')


	if jump and is_on_floor():
		if !inLocked:
			velocity.y += jumpSpeed
			jumping = true
		elif jump_rel:
			inLocked = false
			jump_rel = false
	if right:
		if !inLocked:
			velocity.x += moveSpeed
		elif right_rel:
			inLocked = false
			right_rel = false
	if left:
		if !inLocked:
			velocity.x -= moveSpeed
		elif left_rel:
			inLocked = false
			left_rel = false
	
	if interact && is_on_floor():
		interacting = true
		inLocked = true
		

func _physics_process(delta):
		
	velocity.x = 0
	get_input()
	
	if jumping || !is_on_floor():
		velocity.y += gravity / 10
	else:
		velocity.y += gravity
		
	if velocity.y > 0:
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func _process(delta):
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	$AnimatedSprite.speed_scale = 1.5
	if airborne:
		moveSpeed = speed 
	else:
		moveSpeed = speed
	
	if Input.is_key_pressed(KEY_K):
		dead = true
		
	if !dead:
		if interacting:
			$AnimatedSprite.speed_scale = 3
			$AnimatedSprite.play("Attack")
			if $AnimatedSprite.frame == 7:
				interacting = false
		elif !is_on_floor():
			airborne = true
			soundPlayer.stop()
			
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
			if !inLocked:
				airborne = false
				if $AnimatedSprite.animation == "Fall":
					$AnimatedSprite.animation = "Run Start"
				fallFlag = false
				
				if soundPlayer.get_playback_position() >= 0.3:
					soundPlayer.stop()
					pitchFlag = !pitchFlag;

				if right:
					if !soundPlayer.is_playing():
						if !pitchFlag:
							soundPlayer.set_pitch_scale(1.5)
						else:
							soundPlayer.set_pitch_scale(1)
						soundPlayer.play(0)
					$AnimatedSprite.flip_h = false
					if !running:
						$AnimatedSprite.speed_scale = 0.2
						$AnimatedSprite.play("Run Start")
						running = true
					elif $AnimatedSprite.frame == 1:
						$AnimatedSprite.play("Run")
					
				if left:
					if !soundPlayer.is_playing():
						if !pitchFlag:
							soundPlayer.set_pitch_scale(1.5)
						else:
							soundPlayer.set_pitch_scale(1)
						soundPlayer.play(0)
					$AnimatedSprite.flip_h = true
					if !running:
						$AnimatedSprite.speed_scale = 0.2
						$AnimatedSprite.play("Run Start")
						running = true
					elif $AnimatedSprite.frame == 1:
						$AnimatedSprite.play("Run")
			if !using:
				if velocity == Vector2():
					soundPlayer.stop()
					$AnimatedSprite.speed_scale = 0.25
					$AnimatedSprite.play("Idle")
					running = false
	else:
		$AnimatedSprite.play("Death")
		if $AnimatedSprite.animation == "Death":
			inLocked = true
			if !dying && $AnimatedSprite.frame == 7:
				$"Death Timer".start(1)
				dying = true
				
				
			
		

func _on_wallJump_Collider_L_body_entered(body):
	wallJumpEnable = true
	bounceDir = 1

func _on_wallJump_Collider_R_body_entered(body):
	wallJumpEnable = true
	bounceDir = -1


func _on_Death_Hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		dead = true


func _on_Timer_timeout():
	get_tree().reload_current_scene()
