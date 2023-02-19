extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$AnimatedSprite.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass # Replace with function body.
