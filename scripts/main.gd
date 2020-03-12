extends Node2D

onready var screen_size = get_viewport_rect().size

var shadow_sp_1
var shadow_sp_2
var shadow_sp_3

var hiscore = 0
var unlocked = 0
var chosen_type = 0
var sfx = true
var music = true

var Interstitial_ready = false
var ads_allowed = true

var games_played_no_ad = 0

func _ready():
	$player.position = screen_size/2
	$arena.position = screen_size/2
	shadow_sp_1 = randf() * 2
	shadow_sp_2 = randf() * 2
	shadow_sp_3 = randf() * 2
	$CanvasLayer/HUD._set_init_sound(music,sfx)
	

func _physics_process(_delta):
	$shadow.position.x += shadow_sp_1
	$shadow2.position.x += shadow_sp_2
	$shadow3.position.x += shadow_sp_3
	if $shadow.position.x > screen_size.x + 100:
		$shadow.position = Vector2(-100, (screen_size.y * randf()))
		shadow_sp_1 = randf() * 2
	if $shadow2.position.x > screen_size.x + 100:
		$shadow2.position = Vector2(-100, (screen_size.y * randf()))
		shadow_sp_2 = randf() * 2
	if $shadow3.position.x > screen_size.x + 100:
		$shadow3.position = Vector2(-100, (screen_size.y * randf()))
		shadow_sp_3 = randf() * 2

func _update(type, num, sec_num):
	if type == 1:
		hiscore = num
	elif type == 2:
		unlocked = num
		chosen_type = sec_num
	elif type ==3:
		if num == 1:
			sfx = sec_num
		elif num == 2:
			music = sec_num

func _save():
	var save_dict = {
		hiscore=hiscore,
		temple={
			unlocked=unlocked,
			chosen_type=chosen_type
		},
		sound={
			music=music,
			sfx=sfx
		}
	}
	return save_dict

func _on_InterstitialTimer_timeout():
	Interstitial_ready = true

func _on_DifficultyTimer_timeout():
	get_node("spawner")._inc_difficulty()
