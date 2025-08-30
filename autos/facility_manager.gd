# facility_manager.gd
extends Node

signal facility_changed(new_facility: Facility)

var current_facility: Facility
var facilities: Array[Facility] = []

func register_facility(facility: Facility) -> void:
	if not facility in facilities:
		
		# Setup Resources
		var resource_manager = facility.get_node("Panel/MarginContainer/VBoxContainer/ResourceManager")
		var resources_for_facility = ResourceValues.facilities[facility.facility_name.to_lower()]
		for resource in resources_for_facility:
			print('resource for facility', resource)
			facility.add_resource(resource, preload("res://resources/resource.tscn"))
		
		facility.postion_resources()
		resource_manager.initialize()
		
		# Connect back button
		var back_bttn = facility.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/Back")
		if back_bttn and not back_bttn.is_connected("pressed", Callable(self, "_on_back_button_pressed")):
			back_bttn.connect("pressed", Callable(self, "_on_back_button_pressed"))
		
		# Add facility to facilities container
		facility.hide()
		
		facilities.append(facility)
		
		print("Registerd Facility: ", facility)

func switch_to_facility(facility_name: String) -> bool:
	print("global resources: ", ResourceValues.resources)
	for facility in facilities:
		if facility.facility_name == facility_name:
			_transition_to(facility)
			return true
	return false
	

func _transition_to(new_facility: Facility):
	#if current_facility:
		#current_facility.hide()
	hide_current_facility()
	
	current_facility = new_facility
	current_facility.show()
	facility_changed.emit(current_facility)
	print('Facility Changed', new_facility)
	
func hide_current_facility():
	if current_facility:
		current_facility.hide()
	
func _on_back_button_pressed():
	hide_current_facility()
	
	
		
	
	
