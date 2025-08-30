extends Control

@export var resources: Dictionary = {}
var facility_bttn_container: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	facility_bttn_container = $Panel/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer

	for facility in $Facilities.get_children():
		FacilityManager.register_facility(facility)
		
		var facility_bttn := Button.new()
		facility_bttn.text = facility.facility_name.to_upper()
		facility_bttn.custom_minimum_size = Vector2(200, 100)
		
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(200, 100)
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		
		hbox.add_child(facility_bttn)
		facility_bttn_container.add_child(hbox)
		
		facility_bttn.connect("pressed", Callable(self, "_on_facility_button_pressed").bind(facility))



func _on_facility_button_pressed(facility):
	FacilityManager.switch_to_facility(facility.facility_name)

func _on_button_pressed():
	#get_tree().change_scene_to_file("res://facility.tscn")
	FacilityManager.switch_to_facility('Cave')
	
	
func _on_explore_button_pressed():
	get_tree().change_scene_to_file("res://node_map/map.tscn")


func _on_ship_pressed():
	get_tree().change_scene_to_file("res://ship_control.tscn")


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		ShipValues.hasLaserBeam = false
		ShipValues.hasBullets = true
	else:
		ShipValues.hasLaserBeam = false
		ShipValues.hasBullets = true
