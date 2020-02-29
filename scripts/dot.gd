extends Node2D

var SPEED = 500
export (PackedScene) var Sounds

onready var player = get_node("/root/main/player")
var velocity = Vector2()

var track = false
var xneg = 1
var yneg = 1
var xvel = randf()
var yvel = randf()

func _ready():
	var xrng = randf()
	var yrng = randf()
	if xrng >= .5:
		xneg = -1
	if yrng >= .5:
		yneg = -1

func _process(delta):
	var player_pos = player.global_position
	var pos_dif = player_pos - global_position
	var angle = atan2(pos_dif.y,pos_dif.x)
	var speed
#PRE TRACK
	if not track:
		velocity.x = xvel * xneg
		velocity.y = yvel * yneg
		speed = randf() * SPEED
	else:
		velocity.x = cos(angle)
		velocity.y = sin(angle)
		speed = SPEED
	velocity = velocity.normalized() * speed
	position += velocity * delta
#DELETE
	if abs(pos_dif.x) < 5 and abs(pos_dif.y) < 5:
		var sound = Sounds.instance()
		get_node("/root/main").call_deferred("add_child", sound)
		sound._set_sound("water_drop")
		get_node("/root/main/player/art_bloom").modulate.a += 0.125
		queue_free()

func _on_Timer_timeout():
	track = true
