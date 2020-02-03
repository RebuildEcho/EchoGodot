extends Label

export (float) var timeUntilAllVisible #milliseconds

var time = 0
var oneCharTime

var shouldStart = false

func _ready():
	visible_characters = 0
	oneCharTime = timeUntilAllVisible / get_total_character_count()

func _process(delta):
	if shouldStart:
		time += delta
		if time > oneCharTime:
			if visible_characters < get_total_character_count():
				visible_characters = visible_characters + 1
				time = 0
			else:
				shouldStart = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		shouldStart = true
