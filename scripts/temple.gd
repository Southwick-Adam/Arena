extends Node2D

export (PackedScene) var Sounds
export (PackedScene) var Unlock
export (PackedScene) var Shop

var limit_1 = 100
var limit_2 = 250
var limit_3 = 500
var limit_4 = 800
var limit_5 = 1200
var hiscore = 0

var type
var ult_type
var chosen_type = 0
var unlocked = 0
var unlocking = false
var gong_timer = 0.2
onready var pendant_icon = $temple/pendant/icon
onready var pendant = $temple/pendant
onready var glow = $temple/glow
onready var icon = $temple/choose/icon
onready var player = get_node("/root/main/player")

func _ready():
	$temple.global_position = player.global_position
	type = get_node("/root/main").chosen_type
	unlocked = get_node("/root/main").unlocked
	_on_choose_pressed()

func _score_update(num):
	hiscore = num

func _process(delta):
	var god = $temple/God
	var ability = $temple/ability
#HEPHESTUS
	if type == 1:
		god.text = ("Hephaestus")
		if unlocked >= 1:
			icon.texture = preload("res://assets/UI/helm.png")
			ability.text = ("Helm of the Blacksmith")
		else:
			icon.texture = preload("res://assets/temple/lock.png")
			if hiscore >= limit_1:
				ability.text = ("Unlock")
			else:
				ability.text = str(limit_1) + (" points needed")
#ARES
	elif type == 2:
		god.text = ("Ares")
		if unlocked >= 2:
			icon.texture = preload("res://assets/UI/flame.png")
			ability.text = ("Blaze of War")
		else:
			icon.texture = preload("res://assets/temple/lock.png")
			if hiscore >= limit_2:
				ability.text = ("Unlock")
			else:
				ability.text = str(limit_2) + (" points needed")
#ARTEMIS
	elif type == 3:
		god.text = ("Artemis")
		if unlocked >= 3:
			icon.texture = preload("res://assets/UI/bow.png")
			ability.text = ("Blood of the Huntress")
		else:
			icon.texture = preload("res://assets/temple/lock.png")
			if hiscore >= limit_3:
				ability.text = ("Unlock")
			else:
				ability.text = str(limit_3) + (" points needed")
#APOLLO
	elif type == 4:
		god.text = ("Apollo")
		if unlocked >= 4:
			icon.texture = preload("res://assets/UI/sun.png")
			ability.text = ("Light of the Sun")
		else:
			icon.texture = preload("res://assets/temple/lock.png")
			if hiscore >= limit_4:
				ability.text = ("Unlock")
			else:
				ability.text = str(limit_4) + (" points needed")
#ZEUS
	elif type == 5:
		god.text = ("Zeus")
		if unlocked >= 5:
			icon.texture = preload("res://assets/UI/lightning.png")
			ability.text = ("Shadow of the King")
		else:
			icon.texture = preload("res://assets/temple/lock.png")
			if hiscore >= limit_5:
				ability.text = ("Unlock")
			else:
				ability.text = str(limit_5) + (" points needed")
#NULL
	if chosen_type == 0:
		pendant.modulate = Color(0.92549, 0.92549, 0.87451)
		glow.modulate = Color(0.92549, 0.92549, 0.87451)
		pendant_icon.hide()
	else:
		pendant_icon.show()
#TIMER
	if gong_timer > 0:
		gong_timer -= delta

func _on_right_pressed():
	if not unlocking:
		if type < 5:
			type += 1

func _on_left_pressed():
	if not unlocking:
		if type > 1:
			type -= 1

func _on_choose_pressed():
	if not icon.texture == preload("res://assets/temple/lock.png"):
		chosen_type = type
#INITIALIZE WITH NO ULT PICKED
		if chosen_type == 0:
			ult_type = 0
			type = 1
	#HEPHESTUS
		if chosen_type == 1:
			if ult_type == 1:
				chosen_type = 0
				ult_type = 0
			else:
				pendant.modulate = Color(0.937255, 0.705882, 0.156863)
				glow.modulate =  Color(0.937255, 0.705882, 0.156863)
				pendant_icon.texture = preload("res://assets/UI/helm.png")
				ult_type = 1
				_gong()
	#ARIES
		elif chosen_type == 2:
			if ult_type == 3:
				chosen_type = 0
				ult_type = 0
			else:
				pendant.modulate = Color(0.839216, 0.113725, 0.113725)
				glow.modulate =  Color(0.839216, 0.113725, 0.113725)
				pendant_icon.texture = preload("res://assets/UI/flame.png")
				ult_type = 3
				_gong()
	#ARTEMIS
		elif chosen_type == 3:
			if ult_type == 5:
				chosen_type = 0
				ult_type = 0
			else:
				pendant.modulate = Color(0.458824, 0.047059, 0.152941)
				glow.modulate =  Color(0.458824, 0.047059, 0.152941)
				pendant_icon.texture = preload("res://assets/UI/bow.png")
				ult_type = 5
				_gong()
	#APOLLO
		elif chosen_type == 4:
			if ult_type == 4:
				chosen_type = 0
				ult_type = 0
			else:
				pendant.modulate = Color(0.145098, 0.854902, 0.854902)
				glow.modulate =  Color(0.145098, 0.854902, 0.854902)
				pendant_icon.texture = preload("res://assets/UI/sun.png")
				ult_type = 4
				_gong()
	#ZEUS
		elif chosen_type == 5:
			if ult_type == 2:
				chosen_type = 0
				ult_type = 0
			else:
				pendant.modulate = Color(0.282353, 0.129412, 0.447059)
				glow.modulate =  Color(0.282353, 0.129412, 0.447059)
				pendant_icon.texture = preload("res://assets/UI/lightning.png")
				ult_type = 2
				_gong()
#UNLOCKING
	else:
		if hiscore >= limit_1 and type == 1:
			unlocked = 1
			_unlock()
		elif hiscore >= limit_2 and type == 2:
			unlocked = 2
			_unlock()
		elif hiscore >= limit_3 and type == 3:
			unlocked = 3
			_unlock()
		elif hiscore >= limit_4 and type == 4:
			unlocked = 4
			_unlock()
		elif hiscore >= limit_5 and type == 5:
			unlocked = 5
			_unlock()
	player.ult_type = ult_type

func _unlock():
	chosen_type = 0
	$temple/choose/icon.hide()
	$temple/God.hide()
	$temple/ability.hide()
	var sound = Sounds.instance()
	get_node("/root/main").call_deferred("add_child", sound)
	sound._set_sound("unlock")
	var node = Unlock.instance()
	get_node("/root/main").call_deferred("add_child", node)
	node.global_position = $temple/choose/icon.global_position
	unlocking = true
	$unlockTimer.start()

func _on_unlockTimer_timeout():
	$temple/choose/icon.show()
	$temple/God.show()
	$temple/ability.show()
	unlocking = false

func _on_x_pressed():
	get_node("/root/main")._update(2, unlocked, chosen_type)
	data._save_data() #SAVE THE META PROGRESSION
	get_node("/root/main/CanvasLayer/start_screen")._game_over()
	queue_free()

func _on_shop_pressed():
	var node = Shop.instance()
	get_node("/root/main").call_deferred("add_child", node)
	self.hide()
	
func _gong():
	if gong_timer <= 0:
		var sound = Sounds.instance()
		get_node("/root/main").call_deferred("add_child", sound)
		sound._set_sound("gong")
