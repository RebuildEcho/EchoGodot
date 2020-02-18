extends KinematicBody2D

export (int) var speed = 200
var moveSpeed
export (int) var jumpSpeed = -400
export (int) var bounceSpeed = -400
export (float) var gravity = 100

var currAnim
var prevAnim
var startAnim
var finAnim
var animLock
var animFlag = false
#If an animation needs to play for full duration add its name here
var switchAtEnd = ["Hit", "RunStart", "RunStop", "Jump", "Land"]

var running
var wallJumpEnable
var fallFlag
var pitchFlag = false

var right_rel = false
var left_rel = false
var jump_rel = false

var dying = false
var checkpointPosition
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
	$AnimationPlayer.play("Idle")
	currAnim = "Idle"
	prevAnim = "Idle"
	startAnim = false
	finAnim = false
	animLock = false
	moveSpeed = speed
	bounceDir = 0
	running = false
	fallFlag = false
	wallJumpEnable = false
	inLocked = false
	using = false
	dead = false
	checkpointPosition = global_position
	
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
	var jump = Input.is_action_pressed('ui_jump')
	var interact = Input.is_action_pressed('ui_fire')
	
	if Input.is_key_pressed(KEY_K):
		dead = true
	

	#add sound statements here
	
	if soundPlayer.get_playback_position() >= 0.3:
		soundPlayer.stop()
		pitchFlag = !pitchFlag;
		
	if !soundPlayer.is_playing():
		if !pitchFlag:
			soundPlayer.set_pitch_scale(1.5)
		else:
			soundPlayer.set_pitch_scale(1)
		if currAnim == "Run":
			soundPlayer.play(0)


	#Add animation control statements here
		
	if !dead:
		if is_on_floor():
			if !animLock:
				if right && currAnim != "Run":
					$AnimationSprites.scale.x = 1
					if !animFlag:
						animFlag = true
						print_debug(animFlag)
						currAnim = "RunStart"
					else:
						currAnim = "Run"
					
				if left && currAnim != "Run":
					$AnimationSprites.scale.x = -1
					if !animFlag:
						animFlag = true
						currAnim = "RunStart"
					else:
						currAnim = "Run"		
					
				if velocity == Vector2(0,0):
					currAnim = "Idle"
					animFlag = false
					
				if interact:
					currAnim = "Hit"
				if jump:
					currAnim = "Jump"
		else:
			currAnim = "Airborne"
			if prevAnim == "Airborne" && is_on_floor():
				currAnim = "Land"
	else:
		inLocked = true
		currAnim = "Death"
		if $"Death Timer".time_left == 0:
			$"Death Timer".start(1)
			
	switch_animation()
	
func switch_animation():
		
	if !animLock:
		if prevAnim != currAnim:
			finAnim = true
			startAnim = true
		if finAnim:
			$AnimationPlayer.stop()
			finAnim = false
		if startAnim:
			$AnimationPlayer.play(currAnim)
			$AnimationSprites.get_node(prevAnim).hide()
			$AnimationSprites.get_node(currAnim).show()
			startAnim = false
		if prevAnim != currAnim:
			prevAnim = currAnim
		if switchAtEnd.has(currAnim):
			print_debug(currAnim)
			animLock = true	
		if animLock:
			$"Lock Timer".start($AnimationPlayer.current_animation_length)
		
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
	dead = false
	global_position = checkpointPosition

func _on_Lock_Timer_timeout():
	animLock = false

#	if !dead:
#		if interacting:
#			$AnimatedSprite.speed_scale = 3
#			$AnimatedSprite.play("Attack")
#			if $AnimatedSprite.frame == 7:
#				interacting = false
#		elif !is_on_floor():
#			airborne = true
#			soundPlayer.stop()
#
#			if !fallFlag:
#				$AnimatedSprite.play("Fall Start")
#				fallFlag = true
#			elif $AnimatedSprite.frame > 0:
#				$AnimatedSprite.play("Fall")
#
#			if right:
#				$AnimatedSprite.flip_h = false
#			if left:
#				$AnimatedSprite.flip_h = true
#
#		else:
#			if !inLocked:
#				airborne = false
#				if $AnimatedSprite.animation == "Fall":
#					$AnimatedSprite.animation = "Run Start"
#				fallFlag = false
#
#				if soundPlayer.get_playback_position() >= 0.3:
#					soundPlayer.stop()
#					pitchFlag = !pitchFlag;
#
#				if right:
#					if !soundPlayer.is_playing():
#						if !pitchFlag:
#							soundPlayer.set_pitch_scale(1.5)
#						else:
#							soundPlayer.set_pitch_scale(1)
#						soundPlayer.play(0)
#					$AnimatedSprite.flip_h = false
#					if !running:
#						$AnimatedSprite.speed_scale = 0.2
#						$AnimatedSprite.play("Run Start")
#						running = true
#					elif $AnimatedSprite.frame == 1:
#						$AnimatedSprite.play("Run")
#
#				if left:
#					if !soundPlayer.is_playing():
#						if !pitchFlag:
#							soundPlayer.set_pitch_scale(1.5)
#						else:
#							soundPlayer.set_pitch_scale(1)
#						soundPlayer.play(0)
#					$AnimatedSprite.flip_h = true
#					if !running:
#						$AnimatedSprite.speed_scale = 0.2
#						$AnimatedSprite.play("Run Start")
#						running = true
#					elif $AnimatedSprite.frame == 1:
#						$AnimatedSprite.play("Run")
#			if !using:
#				if velocity == Vector2():
#					soundPlayer.stop()
#					$AnimatedSprite.speed_scale = 0.25
#					$AnimatedSprite.play("Idle")
#					running = false
#	else:
#		$AnimatedSprite.play("Death")
#		if $AnimatedSprite.animation == "Death":
#			inLocked = true
#			if !dying && $AnimatedSprite.frame == 7:
#				$"Death Timer".start(1)
#				dying = true
#
				
			






