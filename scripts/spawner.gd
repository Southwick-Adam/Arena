extends Node

export (PackedScene) var Enemy
export (PackedScene) var Item
var enemy_count = 0
var max_enemy_count = 6
var two_chance = 0.8

func _ready():
	randomize()

func _on_EnemyTimer_timeout():
	var num_rng = randf()
	if num_rng > two_chance:
		_spawn()
	_spawn()
	$EnemyTimer.set_wait_time(rand_range(1.5, 3))

func _process(_delta):
	if enemy_count >= max_enemy_count:
		$EnemyTimer.paused = true
	if $EnemyTimer.is_paused() == true:
		if enemy_count < max_enemy_count - 3:
			$EnemyTimer.paused = false

func _spawn():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Enemy.instance()
	add_child(mob)
	mob.position = $MobPath/MobSpawnLocation.position
	var target = get_node("/root/main/player").global_position
	var pos_dif = target - mob.global_position
	var direction = atan2(pos_dif.y,pos_dif.x)
	mob.rotation = direction
	enemy_count += 1

func _on_ItemTimer_timeout():
	_item_spawn()

func _item_spawn():
	var rand_location = Vector2(650 * randf(), 420 * randf()) + Vector2(35, 30)
	var node = Item.instance()
	add_child(node)
	node.position = rand_location

func _game_over():
	$EnemyTimer.stop()
	$ItemTimer.stop()

func _new_game():
	$EnemyTimer.start()
	$ItemTimer.start()
