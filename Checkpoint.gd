extends Node2D

#Player can only activate a checkpoint if it is not yet used
export (bool) var used

func _ready():
	used = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_Area_body_entered(body):
	if body.is_in_group("player") && !used:
		body.checkpointPosition = global_position
		used = true
