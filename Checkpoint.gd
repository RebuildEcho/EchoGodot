extends Node2D

#Player can only activate a checkpoint if it is not yet used
export (bool) var used
var animActive

func _ready():
	$Bootup.show()
	used = false
	animActive = false


func _process(delta):
	if used:
		if !$AnimationPlayer.is_playing():
			if !animActive:
				$AnimationPlayer.play("Active")
				animActive = true
				$Active.show()
				$Bootup.hide()


func _on_Checkpoint_Area_body_entered(body):
	if body.is_in_group("player") && !used:
		body.checkpointPosition = global_position
		used = true
		$AnimationPlayer.play("Bootup")
