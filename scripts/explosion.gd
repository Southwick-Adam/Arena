extends Node2D

export (PackedScene) var Burn
export (PackedScene) var Sounds

func _ready():
	var sound = Sounds.instance()
	get_node("/root/main").call_deferred("add_child", sound)
	sound._set_sound("boom")

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		var node = Burn.instance()
		get_node("/root/main").call_deferred("add_child", node)
		node.set_global_position(area.global_position)
		area.get_parent()._death()


func _on_AnimationPlayer_animation_finished(anim):
	if anim == ("boom"):
		queue_free()
