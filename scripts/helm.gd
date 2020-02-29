extends Node2D

var TO = false
var func_switched = false

func _ready():
	$Area2D/Sprite.modulate = Color(1, 0.972549, 0.298039, 0.4)
	scale = Vector2(.1,.1)

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("enemy_bolt"):
		area.queue_free()
		$Area2D/Sprite.scale += Vector2(.2,.2)
		$Area2D/Sprite.modulate.a += 0.05
		$Timer.start()
		$AudioStreamPlayer2D.play()

func _physics_process(_delta):
	if scale.x < 1:
		scale += Vector2(.03,.03)
	else:
		if not func_switched:
			_start()
	if TO:
		$Area2D/Sprite.modulate.a -= .05
	if $Area2D/Sprite.modulate.a < .01:
		queue_free()

func _on_Timer_timeout():
	$Area2D/Sprite.scale -= Vector2(.1,.1)

func _start():
	$Area2D.set_deferred("monitoring", true)
	$TimeOut.start()
	func_switched = true

func _on_TimeOut_timeout():
	TO = true
	$Area2D.set_deferred("monitoring", false)
