extends KinematicBody2D

var origin = Vector2()
var velocity = Vector2()
export (int) var gravity = 30
export (int) var deviation = 400
export (int) var speed = 150
var dir

# Called when the node enters the scene tree for the first time.
func _ready():
	dir = 1
	origin = global_position

func _physics_process(delta):
	velocity.x = speed*dir
	velocity = move_and_slide(velocity, Vector2(0,-1))
	velocity.y += gravity
	
	if is_on_wall():
		dir = dir*-1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( (origin - global_position).length() > deviation):
		dir = dir*-1
		
	$AnimatedSprite.play("Walk")
	
	if dir > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
