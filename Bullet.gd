extends RigidBody2D

var forces = 50
var speed = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	applied_force = dirt*forces
	
	pass # Replace with function body.

var dirt = Vector2(0,-1)
func setDirt(_dirt:Vector2):
	dirt = _dirt
	pass
#
#func setDegree(deg):
#	rotation_degrees = deg

func setAngle(ang):
	rotate(ang)
	
export var lifeTime = 0.8 #sec
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifeTime-=delta
	if lifeTime <= 0:
		effect()
		get_parent().remove_child(self)
		self.queue_free()
		
	pass
	

var preloadExplotion = preload("res://explosion.tscn")
func effect():
	var explotion = preloadExplotion.instance()
	explotion.position = self.position
	get_tree().get_current_scene().add_child(explotion)
	pass
	


func _on_Bullet_body_entered(body):
	if body is Enemy:
		effect()
		body.HP -= 3
		if body.HP<=0:
			body.queue_free()
		self.queue_free()
	pass # Replace with function body.
