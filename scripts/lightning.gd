extends Node2D

var target

func _ready():
	var tex_rng = randf()
	if tex_rng < 0.33:
		$Area2D/Sprite.frame = 0
	elif tex_rng >= 0.33 and tex_rng < 0.66: 
		$Area2D/Sprite.frame = 1
	else:
		$Area2D/Sprite.frame = 2
	$AudioStreamPlayer2D.pitch_scale -= randf() * 0.2

func _physics_process(_delta):
	position.y += 40

func _target(enemy):
	target = enemy

func _on_Area2D_area_entered(area):
	if area == target:
		area.get_parent().modulate = Color(0.458824, 0.458824, 0.458824)
		area.get_parent()._death()
		$Area2D.queue_free()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
