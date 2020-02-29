extends Node2D

var ending = false

func _ready():
	modulate.a = 0

func _process(_delta):
	if ending:
		if modulate.a > 0.05:
			modulate.a -= 0.03
		else:
			queue_free()
	else:
		if modulate.a < 0.4:
			modulate.a += 0.03
	rotate(0.05)

func _color(type):
	if type == 1:
		modulate = Color(0.937255, 0.705882, 0.156863)
	elif type == 2:
		modulate = Color(0.282353, 0.129412, 0.447059)
	elif type == 3:
		modulate = Color(0.839216, 0.113725, 0.113725)
	elif type == 4:
		modulate = Color(0.145098, 0.854902, 0.854902)
	elif type == 5:
		modulate = Color(0.458824, 0.047059, 0.152941)

func _end():
	ending = true
