extends Node2D

export (PackedScene) var Burn

var fade = false

func _ready():
	$Area2D.scale = Vector2(1,.1)

func _physics_process(_delta):
	if $Area2D.scale.y < 1:
		$Area2D.scale.y += 0.05
	if fade:
		modulate.a -= 0.05
	if modulate.a < 0.1:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		var node = Burn.instance()
		get_node("/root/main").call_deferred("add_child", node)
		node.set_global_position(area.global_position)
		area.get_parent()._death()
	if area.get_parent().is_in_group("enemy_bolt"):
		area.queue_free()

func _on_Timer_timeout():
	fade = true
