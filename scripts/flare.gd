extends Node2D

var velocity = Vector2()

export (PackedScene) var Explosion

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += velocity * delta

func _go(rot):
	var SPEED = 400
	velocity.x = cos(rot)
	velocity.y = sin(rot)
	velocity = velocity * SPEED

func _on_Timer_timeout():
	var node = Explosion.instance()
	get_node("/root/main").call_deferred("add_child", node)
	node.set_global_position(global_position)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()