extends Control

@export var resources: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://facility.tscn")


func _on_explore_button_pressed():
	get_tree().change_scene_to_file("res://map.tscn")


func _on_ship_pressed():
	get_tree().change_scene_to_file("res://ship_control.tscn")


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		print("on")
		ShipValues.hasLaserBeam = false
		ShipValues.hasBullets = true
	else:
		print("off")
		ShipValues.hasLaserBeam = false
		ShipValues.hasBullets = true
