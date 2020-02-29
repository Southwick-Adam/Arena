extends Node2D

func _ready():
	pass # Replace with function body.

func _process(_delta):
	$bloom.rotate(0.5)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
