extends Node2D

export (PackedScene) var SaveMe

func _ready():
	rotation = randf() * 2 * PI
	scale = Vector2(0.1,0.1)

func _process(_delta):
	if scale.x < 1:
		scale += Vector2(0.01,0.01)
		$Timer.start()

func _on_Timer_timeout():
	if get_node("/root/main/player").respawns < 2:
		var node = SaveMe.instance()
		get_node("/root/main/CanvasLayer").call_deferred("add_child", node)
	else:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.get_parent().queue_free()
		get_node("/root/main/CanvasLayer/start_screen")._game_over()
		get_node("/root/main/spawner").enemy_count = 0
		get_node("/root/main/player").respawns = 0
	queue_free()
