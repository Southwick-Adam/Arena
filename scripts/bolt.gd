extends Node2D

export (PackedScene) var Dot
export (PackedScene) var Sounds

var velocity = Vector2()

var type
var fade = false
var DeathTimer = 0.6
var artemis = false

func _ready():
	$AudioStreamPlayer2D.pitch_scale -= randf() * 0.15

func _go(rot):
	var SPEED
	if type == 1:
		SPEED = 700
	else:
		SPEED = 350
	velocity.x = cos(rot)
	velocity.y = sin(rot)
	velocity = velocity * SPEED

func _type(type_num):
	type = type_num
	if type == 1: #PLAYER BOLT
		$Area2D/CollisionShape2D.position = Vector2(-3,0)
		$blood.position = Vector2(4.8,0)
	else: #ENEMY BOLT
		$Area2D/CollisionShape2D.position = Vector2(3,0)
		$blood.position = Vector2(9,0)
		$AudioStreamPlayer2D.volume_db -= 5
		$AudioStreamPlayer2D.pitch_scale -= 0.1

func _physics_process(delta):
	if not fade:
		position += velocity * delta
	else:
		DeathTimer -= delta
		if DeathTimer < 0.5:
			$Area2D/Sprite.modulate.a -= 0.05
		if $Area2D/Sprite.modulate.a < 0.05:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_area_entered(area):
	if type == 1: #PLAYER BOLT
		if area.is_in_group("enemy"):
			area.get_parent()._death()
			_hit()
	elif type == 2: #ENEMY BOLT
		if area == get_node("/root/main/player/body"):
			area.get_parent()._hit()
			$Area2D.hide()
			_hit()
		elif area.is_in_group("shield"):
			var sound = Sounds.instance()
			get_node("/root/main").call_deferred("add_child", sound)
			sound._set_sound("shield")
			var sprite = Sprite.new()
			sprite.texture = load("res://assets/weapon/bolt.png")
			if area == get_node("/root/main/player/shield"):
				get_node("/root/main/player/shield").add_child(sprite)
			if area == get_node("/root/main/player/pwr_shield"):
				get_node("/root/main/player/pwr_shield").add_child(sprite)
			sprite.global_position = global_position
			sprite.scale = Vector2(0.6,0.6)
			sprite.z_index = -1
			sprite.global_rotation = global_rotation + PI/2
			sprite.add_to_group("stuck_bolt")
			get_node("/root/main/CanvasLayer/HUD")._score_up(5)
			call_deferred("queue_free")

func _hit():
	$HitTimer.start()
	fade = true
	velocity = Vector2(0,0)
	$Area2D.set_deferred("monitoring", false)
	$Area2D/Sprite.texture = preload("res://assets/weapon/shaft.png")
	if artemis == true:
		_spray()
	else:
		$blood.emitting = true

func _on_HitTimer_timeout():
	queue_free()

func _artemis():
	artemis = true
	$artemist.emitting = true

func _spray():
	var i = 8
	while i > 0:
		var node = Dot.instance()
		get_node("/root/main").call_deferred("add_child", node)
		node.set_global_position(global_position)
		i -= 1
	
