extends Control

export (PackedScene) var Temple

var hiscore = 0
var current_score = 0
onready var score = $MarginContainer/HBoxContainer/VBoxContainer/score/score
onready var label_text = $MarginContainer/HBoxContainer/VBoxContainer/score/text
onready var new_hiscore = $MarginContainer/VBoxContainer/Label

func _ready():
	label_text.text = ("BEST SCORE:")
	hiscore = get_node("/root/main").hiscore
	score.text = str(hiscore)
	new_hiscore.hide()

func _score(num):
	current_score = num

func _game_over():
	label_text.text = ("SCORE:")
	score.text = str(current_score)
	if current_score > hiscore:
		hiscore = current_score
		get_node("/root/main")._update(1, hiscore, null)
		data._save_data()
		new_hiscore.show()
		$MarginContainer/VBoxContainer/Timer.start()
	show()
	_music(1)

func _on_start_btn_pressed():
	get_node("/root/main/spawner")._new_game()
	get_node("/root/main/CanvasLayer/HUD").score = 0
	get_node("/root/main/CanvasLayer/HUD")._new_game()
	get_node("/root/main/player")._new_game(5)
	_new_hiscore_hide()
	_music(2)
	hide()

func _on_score_btn_pressed():
	if label_text.text == ("SCORE:"):
		label_text.text = ("BEST SCORE:")
		score.text = str(hiscore)
	else:
		label_text.text = ("SCORE:")
		score.text = str(current_score)

func _on_temple_btn_pressed():
	var node = Temple.instance()
	get_node("/root/main").call_deferred("add_child", node)
	node._score_update(hiscore)
	_new_hiscore_hide()
	hide()

#NEW HIGHSCORE COLOR FLASH
func _on_Timer_timeout():
	if new_hiscore.modulate == Color(0.505882, 0.113725, 0.705882):
		new_hiscore.modulate = Color(0.662745, 0.768627, 0.282353)
	else:
		new_hiscore.modulate = Color(0.505882, 0.113725, 0.705882)

func _new_hiscore_hide():
	new_hiscore.hide()
	$MarginContainer/VBoxContainer/Timer.stop()

#MUSIC
func _music(song):
	if song == 1 and $music.stream != preload("res://assets/sounds/music/start_screen.ogg"):
		$music.stream = preload("res://assets/sounds/music/start_screen.ogg")
		$music.volume_db = 15
		$music.play()
	elif song == 2:
		$music.stream = preload("res://assets/sounds/music/temple.ogg")
		$music.volume_db = 5
		$music.play()
