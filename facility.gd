class_name Facility
extends Node

#@onready var back_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Back
func _ready():
	pass
	#back_button.connect("pressed", _on_back_pressed)
	#var _resource_manager = get_node("Panel/MarginContainer/ResourceManager")
	
	# Instance and configure resources
	#for resource in ["ore", "metal"]: # Add all your resources here
		#var resource1_scene = load("res://resource.tscn")
		##var resource_instance = resource1_scene.instance()
		#resource_instance.resource_name = resource
		#print(resource_instance)
		#add_child(resource_instance)

#extends Control
#
#var resources = {
	#'metal' = 0,
	#'components' = 0
#}
	#




#func _on_back_pressed():
	#print("preesssss")
	#get_tree().change_scene_to_file("res://main.tscn")
