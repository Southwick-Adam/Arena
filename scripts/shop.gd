extends Node2D

var info = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_x_pressed():
	get_node("/root/main/temple").show()
	queue_free()

func _on_info_pressed():
	if info:
		info = false
		$labels.hide()
	else:
		info = true
		$labels.show()
