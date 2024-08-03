extends Button


#func _ready():
	#self.connect("pressed", _on_pressed)

#func _on_button_pressed():
	#print("presssed")
	#get_tree().change_scene_to_file("res://main.tscn")


func _on_pressed():
	print("presssed")
	get_tree().change_scene_to_file("res://main.tscn")
