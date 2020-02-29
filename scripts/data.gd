extends Node

const SAVE_PATH = "res://save.json"

func _ready():
	_load_data()

func _save_data():
#GET SAVE DATA
	var save_dict = {}
	var saved_nodes = get_tree().get_nodes_in_group("save")
	for node in saved_nodes:
		save_dict[node.get_path()] = node._save()
#CREATE / OPEN SAVE FILE
	var SaveFile = File.new()
	SaveFile.open(SAVE_PATH, File.WRITE)
#WRITE THE DATA INTO THE SAVE FILE
	SaveFile.store_line(to_json(save_dict))
#CLOSE THE FILE
	SaveFile.close()

func _load_data():
#TRY TO LOAD SAVE FILE
	var SaveFile = File.new()
	if not SaveFile.file_exists(SAVE_PATH):
		print("NO SAVED DATA AVAILABLE")
		return
	SaveFile.open(SAVE_PATH, File.READ)
	var data = parse_json(SaveFile.get_as_text())
	
	for node_path in data.keys():
		var node = get_node(node_path)
		for attribute in data[node_path]:
			if attribute == ("hiscore"):
				node.hiscore = data[node_path]["hiscore"]
			elif attribute == ("temple"):
				node.unlocked = data[node_path]["temple"]["unlocked"]
				node.chosen_type = data[node_path]["temple"]["chosen_type"]
			else:
				node.sfx = data[node_path]["sound"]["sfx"]
				node.music = data[node_path]["sound"]["music"]