extends Control

onready var player = get_node("/root/main/player")

var touch = false

func _ready():
	pass

func _process(_delta):
	if touch:
		$bar/NinePatchRect.rect_scale.x -= 0.025
	else:
		$bar/NinePatchRect.rect_scale.x -= 0.003

	if $bar/NinePatchRect.rect_scale.x <= 0:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.get_parent().queue_free()
		var sounds = get_tree().get_nodes_in_group("sound")
		for sound in sounds:
			sound.queue_free()
		get_node("/root/main/CanvasLayer/start_screen")._game_over()
		get_node("/root/main/spawner").enemy_count = 0
		player.respawns = 0
		queue_free()

func _on_ad_pressed():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.get_parent()._respawn()
	var sounds = get_tree().get_nodes_in_group("sound")
	for sound in sounds:
		sound.queue_free()
	get_node("/root/main/spawner/EnemyTimer").set_wait_time(5)
	get_node("/root/main/spawner")._new_game()
	get_node("/root/main/CanvasLayer/HUD")._new_game()
	if player.respawns == 0:
		player._new_game(3)
	elif player.respawns == 1:
		player._new_game(1)
	player.respawns += 1
	queue_free()

#CLOSE SPACE
func _on_space1_pressed():
	touch = true
func _on_space2_pressed():
	touch = true
func _on_space3_pressed():
	touch = true
func _on_space4_pressed():
	touch = true

func _on_space1_released():
	touch = false
func _on_space2_released():
	touch = false
func _on_space3_released():
	touch = false
func _on_space4_released():
	touch = false
