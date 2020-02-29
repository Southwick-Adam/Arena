extends Node2D

export (PackedScene) var Lightning

var fade = false

func _ready():
	scale = Vector2(.1,.1)

func _physics_process(_delta):
	if scale.x < 1:
		scale += Vector2(.01,.01)
	if fade:
		modulate.a -= 0.05
		$AudioStreamPlayer2D.volume_db -= 1
	if modulate.a < 0.1:
		queue_free()

func _on_Timer_timeout():
	fade = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		var node = Lightning.instance()
		get_node("/root/main").call_deferred("add_child", node)
		node.set_global_position(Vector2(area.global_position.x, -100))
		node._target(area)
