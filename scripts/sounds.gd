extends Node2D

var pause = false

func _ready():
	pass # Replace with function body.

func _set_sound(type):
	if type == ("shield"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/wood.wav")
	elif type == ("pwrup"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/pwerup.wav")
		$AudioStreamPlayer.volume_db -= 10
	elif type == ("boom"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/boom.wav")
		$AudioStreamPlayer.volume_db -= 15
	elif type == ("unlock"):
		AudioServer.set_bus_mute(2,1)
		pause = true
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/unlock.wav")
	elif type == ("water_drop"):
		$AudioStreamPlayer.volume_db -= 30
		$AudioStreamPlayer.pitch_scale -= 0.4
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/water_drop.wav")
	elif type == ("gong"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/gong.wav")
		$AudioStreamPlayer.volume_db -= 5
	elif type == ("timp"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/timp.wav")
	elif type == ("funeral"):
		$AudioStreamPlayer.stream = preload("res://assets/sounds/SFX/funeral.ogg")
	$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	if pause and get_node("/root/main/CanvasLayer/HUD").music == true:
		AudioServer.set_bus_mute(2,0)
	queue_free()
