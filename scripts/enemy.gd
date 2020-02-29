extends Node2D

onready var SPEED = rand_range(50,120)
var screen_size
var velocity = Vector2()
var stop = false
var DeathTimer = 0.6
var dead = false
var game_over = false
var reload_timer = .25

export (PackedScene) var Bolt

func _ready():
	scale += Vector2(.1,.1) * randf()
	screen_size = get_viewport_rect().size
#HAT
	var hat_rng = randf()
	if hat_rng < 0.4:
		$Area2D/Sprite/hat.texture = preload("res://assets/enemy/hat1.png")
	elif hat_rng >= 0.4 and hat_rng < 0.8:
		$Area2D/Sprite/hat.texture = preload("res://assets/enemy/hat2.png")
	else:
		$Area2D/Sprite/hat.texture = preload("res://assets/enemy/hat3.png")
	var r_rng = randf()
	var g_rng = randf()
	var b_rng = randf()
	$Area2D/Sprite/hat.modulate = Color(r_rng,g_rng,b_rng)
#EYES
	var eye_rng = randf()
	if eye_rng < .2:
		$Area2D/Sprite/eyes.modulate = Color(0.753906, 0.753906, 0.753906)
	elif eye_rng >= .2 and eye_rng < .4:
		$Area2D/Sprite/eyes.modulate = Color(0.07451, 0.8, 0.392157)
	elif eye_rng >= .4 and eye_rng < .6:
		$Area2D/Sprite/eyes.modulate = Color(0.243137, 0.847059, 0.964706)
	elif eye_rng >= .6 and eye_rng < .8:
		$Area2D/Sprite/eyes.modulate = Color(0.117647, 0.313726, 0.772549)
	else:
		$Area2D/Sprite/eyes.modulate = Color(0.6, 0.419608, 0.894118)
#SKIN
	var skin_rng = randf()
	if skin_rng < .33:
		$Area2D/Sprite.self_modulate = Color(0.929412, 0.8, 0.752941)
	elif skin_rng >= .33 and skin_rng < .66:
		$Area2D/Sprite.self_modulate = Color(0.831373, 0.647059, 0.580392)
	else:
		$Area2D/Sprite.self_modulate = Color(0.643137, 0.392157, 0.235294)
#SOUNDS
	$impact.pitch_scale -= 0.2*randf()
	var grunt_rng = randf()
	if grunt_rng < .2:
		$grunt.stream = preload("res://assets/sounds/SFX/grunt1.wav")
	elif grunt_rng >= .2 and grunt_rng < .4:
		$grunt.stream = preload("res://assets/sounds/SFX/grunt2.wav")
	elif grunt_rng >= .4 and grunt_rng < .6:
		$grunt.stream = preload("res://assets/sounds/SFX/grunt3.wav")
	elif grunt_rng >= .6 and grunt_rng < .8:
		$grunt.stream = preload("res://assets/sounds/SFX/grunt4.wav")
	else:
		$grunt.stream = preload("res://assets/sounds/SFX/grunt5.wav")
	$impact.volume_db -= randf() * 10
	$impact.pitch_scale -= 0.3 * randf()

func _physics_process(delta):
	if not dead:
#MOVEMENT
		if not stop:
			velocity.y = sin(rotation)
			velocity.x = cos(rotation)
			velocity = velocity.normalized() * SPEED
			position += velocity * delta
#RELOAD
		if $Area2D/Sprite/Xbow/Sprite.texture == preload("res://assets/weapon/Xbow.png"):
			reload_timer -= delta
		if reload_timer <= 0:
			$Area2D/Sprite/Xbow/Sprite.texture = preload("res://assets/weapon/Xbow2.png")
			$Area2D/Sprite/Xbow/bolt.show()
			reload_timer = .25
		
	else:
#DEATH
		DeathTimer -= delta
		if DeathTimer > 0.5:
			position -= velocity * delta
		else:
			$Area2D/Sprite.modulate.a -= 0.05
		if $Area2D/Sprite.modulate.a < 0.05 and not game_over:
			get_node("/root/main/spawner").enemy_count -= 1
			queue_free()

func _on_Area2D_area_entered(area):
	if area == get_node("/root/main/arena"):
		stop = true
		$AttackTimer.start()

func _death():
	$impact.play()
	if randf() >= 0.25:
		$grunt.play()
	$AttackTimer.stop()
	dead = true
	$Area2D.set_deferred("monitorable",false)
	$Area2D.set_deferred("monitoring",false)
	$Area2D/Sprite/eyes.modulate = Color(0.121569, 0.113725, 0.141176)
	get_node("/root/main/player")._ult_score_up()
	get_node("/root/main/CanvasLayer/HUD")._score_up(15)

func _on_AttackTimer_timeout():
	_shoot()

func _shoot():
	var bolt = Bolt.instance()
	get_node("/root/main").call_deferred("add_child", bolt)
	bolt.set_global_position($Area2D/Sprite/Xbow/bolt.global_position)
	bolt.add_to_group("enemy_bolt")
	bolt._type(2)
	bolt._go(rotation - PI/40)
	bolt.rotation = (rotation - PI/40)
	$AttackTimer.set_wait_time(rand_range(2, 5))
	$AttackTimer.start()
	$Area2D/Sprite/Xbow/Sprite.texture = preload("res://assets/weapon/Xbow.png")
	$Area2D/Sprite/Xbow/bolt.hide()

func _game_over():
	stop = true
	$AttackTimer.stop()
	$GameOverTimer.start()

func _on_GameOverTimer_timeout():
	game_over = true
	DeathTimer = 0.5
	dead = true

func _respawn():
	game_over = false
	dead = false
	$Area2D/Sprite/aura.show()
	$Area2D/Sprite/Xbow/bolt.hide()
	$RespawnBoltTimer.start()
	$Area2D/Sprite.modulate.a = 1
	$AttackTimer.set_wait_time(rand_range(5,7.5))
	$AttackTimer.start()
	$AuraTimer.start()
	var pos_dif = global_position - get_node("/root/main/player").global_position
	if sqrt(pow(pos_dif.x,2)+pow(pos_dif.y,2)) > 210:
		stop = false

func _on_RespawnBoltTimer_timeout():
	$Area2D/Sprite/Xbow/bolt.show()

func _on_AuraTimer_timeout():
	$Area2D/Sprite/aura.hide()
