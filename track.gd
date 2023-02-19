extends Line2D


export var length = 30
onready var parent = get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	clear_points()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	add_point(parent.global_position)
	
	if points.size()>length:
		remove_point(0);
