class_name Enemy
extends KinematicBody2D



var HP = 100
var force = 25
var speed = 0.1
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.value = HP
	
	randomize()
	
	speed = rand_range(0.1,0.9)
	force = rand_range(1,50)
	
	var scaleValue = force/20.0
	scale = Vector2(scaleValue,scaleValue)
	target = get_parent().get_node("blockhouse")
	pass # Replace with function body.


var vel
func _physics_process(delta):
	vel = self.position.direction_to(target.position) * speed
	vel = move_and_collide(vel)
	$ProgressBar.value = HP
