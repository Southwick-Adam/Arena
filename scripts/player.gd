extends Node2D

export (PackedScene) var Bolt
export (PackedScene) var Helm
export (PackedScene) var Ray
export (PackedScene) var Storm
export (PackedScene) var Flare
export (PackedScene) var Circle
export (PackedScene) var Blood

var shield
var maxhealth = 5
var health
var respawns = 0
var pwr = 0
var pwr_limit = 8
var power_shield = false
var power_bolts = 0
var i_frames = false
var can_shoot = true
var ult_activated = false
var game_over = true
var ult_type = 0   #1 = Hephestus, 2 = Zeus, 3 = Aries, 4 = Apollo, 5 = Artemis
onready var HUD = get_node("/root/main/CanvasLayer/HUD")
onready var HUD_knob = get_node("/root/main/CanvasLayer/HUD/MC/bottomL/VBoxContainer/base/knob")
onready var HUD_base = get_node("/root/main/CanvasLayer/HUD/MC/bottomL/VBoxContainer/base")

signal pwr_shield

func _ready():
	health = maxhealth
	var initial_ult = get_node("/root/main").chosen_type
	ult_type = initial_ult
	if initial_ult == 2:
		ult_type = 3
	elif initial_ult == 3:
		ult_type = 5
	elif initial_ult == 5:
		ult_type = 2
	else:
		ult_type = initial_ult
	set_physics_process(false)

func _physics_process(_delta):
#ROTATION
	if not (ult_activated and ult_type == 4):
		var pos_dif = HUD_knob.global_position - HUD_base.global_position
		var knob_angle = atan2(pos_dif.y,pos_dif.x)
		if HUD_knob.position != Vector2(0,0):
			rotation = (knob_angle - PI/2)
#SHEILD
		if shield:
			$shield.set_deferred("monitorable", true)
			$shield.show()
			$Xbow.hide()
			$point.hide()
#POWER SHIELD
			if power_shield == true:
				$pwr_shield.show()
				$pwr_shield.set_deferred("monitorable",true)
				$PowerUpTimer.paused = false
				emit_signal("pwr_shield")
#CROSSBOW
		else:
			$shield.set_deferred("monitorable", false)
			$shield.hide()
			$Xbow.show()
			$point.show()
			if can_shoot:
				$Xbow.texture = preload("res://assets/weapon/Xbow2.png")
				$Xbow/bolt.show()
#POWER SHIELD
			if power_shield == true:
				$pwr_shield.hide()
				$pwr_shield.set_deferred("monitorable",false)
				$PowerUpTimer.paused = true
#APOLLO ULT
	else:
		$shield.hide()
		$Xbow.hide()
		rotate(0.03)
#ARTEMIS ULT
	if $art_bloom.modulate.a > 0.95:
		_power_up(2)
		$art_bloom.modulate.a = 0

#ULT
func _ult():
	if pwr >= pwr_limit and ult_type != 0:
#MAGIC CIRLCE
		var node = Circle.instance()
		get_node("/root/main").call_deferred("add_child", node)
		node.set_global_position(global_position)
#SCORE
		HUD._score_up(10)
#EFFECT AND TYPE
		if ult_type == 1:
			var ult = Helm.instance()
			get_node("/root/main").call_deferred("add_child", ult)
			ult.set_global_position(global_position)
			$UltTimer.wait_time = 6
			node._color(1)
			$body/Sprite/aura.modulate = Color(0.937255, 0.705882, 0.156863)
			$body/Sprite/aura.show()
		elif ult_type == 2:
			var ult = Storm.instance()
			get_node("/root/main").call_deferred("add_child", ult)
			ult.set_global_position(global_position)
			$UltTimer.wait_time = 6.5
			node._color(2)
			$body/Sprite/aura.modulate = Color(0.282353, 0.129412, 0.447059)
			$body/Sprite/aura.show()
		elif ult_type == 3:
			$UltTimer.wait_time = 5
			$Xbow/bolt.modulate.a = 0
			$flame.show()
			node._color(3)
			$body/Sprite/aura.modulate = Color(0.839216, 0.113725, 0.113725)
			$body/Sprite/aura.show()
		elif ult_type == 4:
			var ult = Ray.instance()
			get_node("/root/main/player").add_child(ult)
			ult.set_global_position($shield/Sprite.global_position)
			$UltTimer.wait_time = 2.5
			node._color(4)
			$body/Sprite/aura.modulate = Color(0.145098, 0.854902, 0.854902)
			$body/Sprite/aura.show()
		elif ult_type == 5:
			$UltTimer.wait_time = 4
			node._color(5)
			$body/Sprite/aura.modulate = Color(0.458824, 0.047059, 0.152941)
			$body/Sprite/aura.show()
#START TIMERS
		pwr = 0
		ult_activated = true
		$UltTimer.start()

func _shoot(angle):
	var bolt = Bolt.instance()
	get_node("/root/main").call_deferred("add_child", bolt)
	bolt.set_global_position($Xbow/bolt/mark.global_position)
	bolt.add_to_group("player_bolt")
	bolt._type(1)
	bolt._go(angle)
	bolt.rotation = (angle)
	if ult_activated and ult_type == 5:
		bolt._artemis()
	$Xbow.texture = preload("res://assets/weapon/Xbow.png")
	$Xbow/bolt.hide()
	$ReloadTimer.start()
	can_shoot = false

func _hit():
	if not (i_frames or (ult_type == 4 and ult_activated == true)):
		health -= 1
		$body/Sprite.modulate = Color(0.423529, 0.129412, 0.129412, 0.6)
		$HitTimer.start()
		$impact.play()
		if health == 0:
			$grunt.stream = preload("res://assets/sounds/SFX/groan.wav")
			game_over = true
			_game_over()
		else:
			$grunt.pitch_scale -= 0.2 * randf()
			$grunt.volume_db -= 5 * randf()
		$grunt.play()
		i_frames = true

func _on_HitTimer_timeout():
	$body/Sprite.modulate = Color(1,1,1,1)
	$grunt.volume_db = -5
	$grunt.pitch_scale = 1.1
	i_frames = false

func _ult_score_up():
	if not ult_activated and ult_type > 0 and not game_over:
		if pwr == (pwr_limit - 1):
			get_node("/root/main/CanvasLayer/HUD/MC/bottomR/buttons/ult_bar").hide()
			get_node("/root/main/CanvasLayer/HUD/MC/bottomR/buttons/ult").show()
		else:
			get_node("/root/main/CanvasLayer/HUD/MC/bottomR/buttons/ult_bar/bar").rect_size.x += (65/pwr_limit)
		pwr += 1

func _power_up(type):
	if type == 1:
		power_bolts = 5
	if type == 2:
		if health < maxhealth:
			health += 1
	elif type == 3:
		power_shield = true
		$PowerUpTimer.start()

func _on_PowerUpTimer_timeout():
	if power_shield == true:
		$pwr_shield.hide()
		$pwr_shield.set_deferred("monitorable",false)
	power_shield = false

func _on_ReloadTimer_timeout():
	can_shoot = true

func _on_UltTimer_timeout():
	ult_activated = false
	get_node("/root/main/magic_circle")._end()
	HUD._ult_bar_show()
	$body/Sprite/aura.hide()
	if ult_type == 3:
		$Xbow/bolt.modulate.a = 1
		$flame.hide()

func _flare(angle):
	var node = Flare.instance()
	get_node("/root/main").call_deferred("add_child", node)
	node.set_global_position($Xbow/bolt/mark.global_position)
	node._go(angle)
	node.rotation = (angle)
	$Xbow.texture = preload("res://assets/weapon/Xbow.png")
	$ReloadTimer.start()
	can_shoot = false

func _bolt_btn():
#SHOOT
	if not shield and can_shoot:
		if not (ult_activated and (ult_type == 4 or ult_type == 3)):
			_shoot(rotation + PI/2)
			if power_bolts > 0:
				_shoot(rotation + PI/2 + PI/8)
				_shoot(rotation + PI/2 - PI/8)
				_shoot(rotation + PI/2 + PI/16)
				_shoot(rotation + PI/2 - PI/16)
				power_bolts -= 1
				HUD._pwr_bolts()
		elif ult_activated and ult_type == 3:
			_flare(rotation + PI/2)
			_flare(rotation + PI/2 + PI/8)
			_flare(rotation + PI/2 - PI/8)

func _shield_signal(set):
	shield = set
	var stuck_bolts = get_tree().get_nodes_in_group("stuck_bolt")
	for stuck_bolt in stuck_bolts:
		stuck_bolt.queue_free()

func _game_over():
	get_node("/root/main/CanvasLayer/start_screen/music").stop()
	pwr = 0
	$UltTimer.stop()
	$PowerUpTimer.stop()
	power_bolts = 0
	if power_shield == true:
		$pwr_shield.hide()
		$pwr_shield.set_deferred("monitorable",false)
	power_shield = false
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.get_parent()._game_over()
	var pwrup = get_tree().get_nodes_in_group("power_up")
	for pwr in pwrup:
		pwr.queue_free()
	var ults = get_tree().get_nodes_in_group("ult")
	for ult in ults:
		ult.queue_free()
	$flame.hide()
	$Xbow/bolt.modulate.a = 1
	ult_activated = false
	HUD._game_over()
	get_node("/root/main/spawner")._game_over()
	set_physics_process(false)
	$shield.hide()
	$Xbow.hide()
	$point.hide()
	$body/Sprite.self_modulate = Color(0.670588, 0.670588, 0.670588)
	modulate = Color(0.811765, 0.811765, 0.811765)
	$body/Sprite/aura.hide()
	var node = Blood.instance()
	get_node("/root/main/player").add_child(node)
	node.set_global_position(global_position)

func _new_game(num):
	set_physics_process(true)
	$grunt.stream = preload("res://assets/sounds/SFX/player_grunt.wav")
	$Xbow.show()
	$point.show()
	$body/Sprite.self_modulate = Color(1,1,1)
	modulate = Color(1,1,1)
	health = num
	game_over = false

func _trigger_temple():
	get_node("/root/main/temple")._remember(ult_type)

#TEMPPPP
func _input(event):
	if event.is_action_pressed("z"):
		_bolt_btn()
