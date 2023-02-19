extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var enable = true
var genInterval = 1.0
var _genInterval = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enable:
		_genInterval -= delta
		if _genInterval <=0:
			_genInterval = genInterval
			genEnemy()
		
		
	pass

var preEnemy = preload("res://Enemy.tscn")
func genEnemy():
	var screenSize = OS.get_screen_size()
	var randomVector = Vector2(rand_range(0,screenSize.x),rand_range(0,screenSize.y))
	var enemy = preEnemy.instance()
	enemy.position = randomVector
	get_tree().get_current_scene().add_child(enemy)
	pass
