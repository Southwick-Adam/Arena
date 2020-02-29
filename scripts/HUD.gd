extends Control

export (PackedScene) var Sounds

onready var player = get_node("/root/main/player")
onready var knob = $MC/bottomL/VBoxContainer/base/knob
var score = 0
var sound = true
var music = true
var showing = false
var game_over = false
var ult_num = 0

func _ready():
	player.connect("pwr_shield", self, "_pwr_shield")
	$MC.hide()
	$MC/left/pwr_up_bars/bolts.hide()
	$MC/left/pwr_up_bars/shield.hide()
	get_node("MC/left/health/glass/MC/H/V1/Particles2D").emitting = false

func _process(_delta):
	if player.health >= 5:
		$MC/left/health/glass/MC/H/V5/TextureRect.texture = preload("res://assets/UI/squareWhite.png")
	else:
		$MC/left/health/glass/MC/H/V5/TextureRect.texture = preload("res://assets/UI/square_shadow.png")
	if player.health >= 4:
		$MC/left/health/glass/MC/H/V4/TextureRect.texture = preload("res://assets/UI/squareWhite.png")
	else:
		$MC/left/health/glass/MC/H/V4/TextureRect.texture = preload("res://assets/UI/square_shadow.png")
	if player.health >= 3:
		$MC/left/health/glass/MC/H/V3/TextureRect.texture = preload("res://assets/UI/squareWhite.png")
	else:
		$MC/left/health/glass/MC/H/V3/TextureRect.texture = preload("res://assets/UI/square_shadow.png")
	if player.health >= 2:
		$MC/left/health/glass/MC/H/V2/TextureRect.texture = preload("res://assets/UI/squareWhite.png")
	else:
		$MC/left/health/glass/MC/H/V2/TextureRect.texture = preload("res://assets/UI/square_shadow.png")
	if player.health >= 1:
		$MC/left/health/glass/MC/H/V1/TextureRect.texture = preload("res://assets/UI/squareWhite.png")
	else:
		$MC/left/health/glass/MC/H/V1/TextureRect.texture = preload("res://assets/UI/square_shadow.png")
#LAST LIFE PARTICLES
	if player.health == 1 and get_node("MC/left/health/glass/MC/H/V1/Particles2D").emitting == false:
		get_node("MC/left/health/glass/MC/H/V1/Particles2D").emitting = true
	elif player.health != 1 and get_node("MC/left/health/glass/MC/H/V1/Particles2D").emitting == true:
		get_node("MC/left/health/glass/MC/H/V1/Particles2D").emitting = false
#GAME OVER
	if game_over:
		if $MC.modulate.a > 0:
			$MC.modulate.a -= 0.01
#TRACKPAD
	var knob_pos_dif = $MC/bottomL/VBoxContainer/base.global_position - get_global_mouse_position()
	if sqrt(pow(abs(knob_pos_dif.x),2) + pow(abs(knob_pos_dif.y),2)) <= 200 and not game_over:
		if sqrt(pow(abs(knob_pos_dif.x),2) + pow(abs(knob_pos_dif.y),2)) <= 60:
			knob.global_position = get_global_mouse_position()
		else:
			var angle = atan2(knob_pos_dif.y,knob_pos_dif.x)
			knob.position = Vector2(-cos(angle),-sin(angle)) * 60
	else:
		knob.position = Vector2(0,0)

func _pwr_bolts_show():
	$MC/left/pwr_up_bars/bolts.show()
	$MC/left/pwr_up_bars/bolts/bar.rect_size.x = 94

func _pwr_shield_show():
	$MC/left/pwr_up_bars/shield.show()
	$MC/left/pwr_up_bars/shield/bar.rect_size.x = 94

func _ult_bar_show():
	$MC/bottomR/buttons/ult_bar.show()
	$MC/bottomR/buttons/ult_bar.modulate.a = 0.46
	$MC/bottomR/buttons/ult_bar/bar.rect_size.x = 0

func _pwr_bolts():
	$MC/left/pwr_up_bars/bolts/bar.rect_size.x -= 18.8
	if $MC/left/pwr_up_bars/bolts/bar.rect_size.x <= 5:
		$Timer_bolt.start()

func _pwr_shield():
	$MC/left/pwr_up_bars/shield/bar.rect_size.x -= 0.2238
	if $MC/left/pwr_up_bars/shield/bar.rect_size.x < 0.5:
		$MC/left/pwr_up_bars/shield.hide()

func _on_Timer_bolt_timeout():
	$MC/left/pwr_up_bars/bolts.hide()

func _score_up(num):
	score += num
	$MC/center/VBoxContainer/number.text = str(score)

func _on_bolt_bttn_pressed():
	if not game_over:
		player._bolt_btn()

func _on_shield_bttn_pressed():
	if not game_over:
		player._shield_signal(true)

func _on_shield_bttn_released():
	player._shield_signal(false)

func _on_ult_bttn_pressed():
	if not game_over:
		var sound = Sounds.instance()
		get_node("/root/main").call_deferred("add_child", sound)
		sound._set_sound("timp")
		$MC/bottomR/buttons/ult.hide()
		player._ult()
		get_node("/root/main/spawner").two_chance -= .1

func _game_over():
	game_over = true
	var sounds = Sounds.instance()
	get_node("/root/main").call_deferred("add_child", sounds)
	sounds._set_sound("funeral")
	$MC/left/pwr_up_bars/shield.hide()
	$MC/left/pwr_up_bars/bolts.hide()
	$MC/bottomR/buttons/ult.hide()
	$MC/left/health/glass/MC/H/V1/Particles2D.emitting = false
	get_node("/root/main/CanvasLayer/start_screen")._score(score)

func _new_game():
	game_over = false
	ult_num = player.ult_type
	$MC/center/VBoxContainer/number.text = str(score)
	if ult_num == 1:
		$MC/bottomR/buttons/ult/icon.texture = preload("res://assets/UI/helm.png")
		$MC/bottomR/buttons/ult.modulate = Color(0.937255, 0.705882, 0.156863)
		$MC/bottomR/buttons/ult_bar.modulate = Color(0.937255, 0.705882, 0.156863)
	elif ult_num == 2:
		$MC/bottomR/buttons/ult/icon.texture = preload("res://assets/UI/lightning.png")
		$MC/bottomR/buttons/ult.modulate = Color(0.282353, 0.129412, 0.447059)
		$MC/bottomR/buttons/ult_bar.modulate = Color(0.282353, 0.129412, 0.447059)
	elif ult_num == 3:
		$MC/bottomR/buttons/ult/icon.texture = preload("res://assets/UI/flame.png")
		$MC/bottomR/buttons/ult.modulate = Color(0.839216, 0.113725, 0.113725)
		$MC/bottomR/buttons/ult_bar.modulate = Color(0.839216, 0.113725, 0.113725)
	elif ult_num == 4:
		$MC/bottomR/buttons/ult/icon.texture = preload("res://assets/UI/sun.png")
		$MC/bottomR/buttons/ult.modulate = Color(0.145098, 0.854902, 0.854902)
		$MC/bottomR/buttons/ult_bar.modulate = Color(0.145098, 0.854902, 0.854902)
	elif ult_num == 5:
		$MC/bottomR/buttons/ult/icon.texture = preload("res://assets/UI/bow.png")
		$MC/bottomR/buttons/ult.modulate = Color(0.458824, 0.047059, 0.152941)
		$MC/bottomR/buttons/ult_bar.modulate = Color(0.458824, 0.047059, 0.152941)
	if ult_num > 0:
		_ult_bar_show()
	else:
		$MC/bottomR/buttons/ult_bar.hide()
	$MC.modulate.a = 1
	$MC.show()

func _on_settings_pressed():
	if showing:
		showing = false
		$VBoxContainer/sound.hide()
		$VBoxContainer/music.hide()
	else:
		showing = true
		$VBoxContainer/sound.show()
		$VBoxContainer/music.show()

func _on_button_pressed():#SOUND
	var main = get_node("/root/main")
	if showing:
		if sound:
			$VBoxContainer/sound.texture = preload("res://assets/UI/nosound.png")
			sound = false
			AudioServer.set_bus_mute(1,1)
		else:
			$VBoxContainer/sound.texture = preload("res://assets/UI/sound.png")
			sound = true
			AudioServer.set_bus_mute(1,0)
		main._update(3,1,sound)
		data._save_data() #SAVE SOUND

func _on_m_button_pressed():#MUSIC
	var main = get_node("/root/main")
	if showing:
		if music:
			$VBoxContainer/music.texture = preload("res://assets/UI/nomusic.png")
			music = false
			AudioServer.set_bus_mute(2,1)
		else:
			$VBoxContainer/music.texture = preload("res://assets/UI/music.png")
			music = true
			AudioServer.set_bus_mute(2,0)
		main._update(3,2,music)
		data._save_data() #SAVE MUSIC

func _set_init_sound(mus, sfx):
	if mus == false:
		$VBoxContainer/music.texture = preload("res://assets/UI/nomusic.png")
		music = false
		AudioServer.set_bus_mute(2,1)
	if sfx == false:
		$VBoxContainer/sound.texture = preload("res://assets/UI/nosound.png")
		sound = false
		AudioServer.set_bus_mute(1,1)
