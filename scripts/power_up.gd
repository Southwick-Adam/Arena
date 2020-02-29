extends Node2D

export (PackedScene) var Sounds

var type
onready var player = get_node("/root/main/player")
onready var HUD = get_node("/root/main/CanvasLayer/HUD")
func _ready():
#TYPE     1 = arrow   2 = health   3 = shield
	var type_rng = randf()
	if type_rng < 0.33:
		type = 1
		$Area2D/Sprite.texture = preload("res://assets/items/powerup_1.png")
		$Area2D/glow.modulate = Color(0.843137, 0.466667, 0.133333, 0.784314)
	elif type_rng >= 0.33 and type_rng < 0.66:
		type = 2
		$Area2D/Sprite.texture = preload("res://assets/items/powerup_2.png")
		$Area2D/glow.modulate = Color(0.843137, 0.133333, 0.133333, 0.784314)
	else:
		type = 3
		$Area2D/Sprite.texture = preload("res://assets/items/powerup_3.png")
		$Area2D/glow.modulate = Color(0.133333, 0.494118, 0.843137, 0.784314)

func _process(_delta):
	rotate(0.01)
#PROXIMITY DELETE
	var pos_dif = player.global_position - global_position
	var pos_dif_hyp = sqrt(pow(pos_dif.x,2)+pow(pos_dif.y,2))
	if pos_dif_hyp < 75:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("player_bolt"):
		if type == 1:
			player._power_up(1)
			HUD._pwr_bolts_show()
		elif type == 2:
			player._power_up(2)
		elif type == 3:
			player._power_up(3)
			HUD._pwr_shield_show()
		var sound = Sounds.instance()
		get_node("/root/main").call_deferred("add_child", sound)
		sound._set_sound("pwrup")
		get_node("/root/main/CanvasLayer/HUD")._score_up(10)
		queue_free()

func _on_Timer_timeout():
	queue_free()
