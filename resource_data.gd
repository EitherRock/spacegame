extends Node

@export var resources = {}
var main = null
var resource_keys = null

func _ready():
	print(resources)
	main = get_node("mainContainer")
	if resources:
		resource_keys = resources.keys()
		for child in get_children():
			for resource in child.get_children():
				var index = resource.get_index()
				var c_resource_name = resource_keys[index]
				var c_button = resource.get_node("MarginContainer/ResourceContainer/Button")
				var c_upgrade_button = resource.get_node("MarginContainer/ResourceContainer/UpgradeButton")
				var progress_bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar")
				progress_bar.value = get_resource_amount(c_resource_name)
				progress_bar.max_value = get_resource_max(c_resource_name)
				var progress_label = progress_bar.get_child(0)
				progress_label.text = str(progress_bar.value) + '/' + str(progress_bar.max_value)
				c_button.text = c_resource_name
				

				c_button.rotation = 90
				
				#c_button.position = progress_bar.global_postion + Vector2(0, -10)
				
				#var progress_bar = resource.get_node("ProgressBar") # Adjust the path as needed
				c_button.connect("pressed", generate_resource.bind(c_resource_name))
				c_upgrade_button.connect("pressed", update_resource_max.bind(c_resource_name, 10))
				if !can_create(c_resource_name):
					c_button.disabled = true
					


func get_resource_amount(resource_name: String) -> int:
	if resources.has(resource_name):
		return resources[resource_name]["amount"]
	return 0

func get_resource_max(resource_name: String) -> int:
	if resources.has(resource_name):
		return resources[resource_name]["max"]
	return 0

func update_subbar(delta, subbar):
	var value = 0
	value += delta *10
	subbar.value = value 

func generate_resource(resource_name):
	var bar = null
	var bar_label = null
	var resource = null
	var sub_bar = null
	var button = null
	if resource_keys:
		for key in resource_keys:
			if key == resource_name:
				resource = main.get_child(resource_keys.find(key))
				bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar")
				bar_label = bar.get_child(0)
				sub_bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar2")

		if can_create(resource_name):
			button = resource.get_node("MarginContainer/ResourceContainer/Button")
			
			button.disabled = true
			var tween = get_tree().create_tween()
			tween.tween_property(sub_bar, "value", 100, 1)
			tween.tween_property(sub_bar, "value", 0, 0)
			
			await tween.finished
			create_resource(resource_name)
			bar.value = get_resource_amount(resource_name)
			bar_label.text = str(bar.value)+'/'+str(bar.max_value)
			button.disabled = false
			
			for res in resources:
				if resources[res]['dependencies']:
					for depend in resources[res]['dependencies']:
						if depend == resource_name:
							if resources[res]['dependencies'][resource_name] <= resources[resource_name]['amount']:
								var indx = resource_keys.find(res)
								var chng_res = main.get_child(indx)
								var bttn = chng_res.get_node("MarginContainer/ResourceContainer/Button")
								bttn.disabled = false
			if !can_create(resource_name):
				button.disabled = true

func add_resource(resource_name: String, amount: int) -> void:
	if resources.has(resource_name):
		resources[resource_name]["amount"] += amount

func can_create(resource_name: String) -> bool:
	if not resources.has(resource_name):
		return false
	for dependency in resources[resource_name]["dependencies"]:
		if get_resource_amount(dependency) < resources[resource_name]["dependencies"][dependency]:
			return false
	return true

func create_resource(resource_name: String) -> bool:
	if can_create(resource_name):
		for dependency in resources[resource_name]["dependencies"]:
			var dependency_bar = null
			var dependency_bar_label = null
			var resource = null
			if resource_keys:
				for key in resource_keys:
					if key == dependency:
						resource = main.get_child(resource_keys.find(dependency))
						dependency_bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar")
						dependency_bar_label = dependency_bar.get_child(0)
			resources[dependency]["amount"] -= resources[resource_name]["dependencies"][dependency]
			dependency_bar.value = get_resource_amount(dependency)
			dependency_bar_label.text = str(dependency_bar.value)+'/'+str(dependency_bar.max_value)
		if resources[resource_name]['amount'] < resources[resource_name]['max']:
			add_resource(resource_name, 1)
		return true
	return false
	

func update_resource_max(resource_name: String, new_max: int) -> void:
	if resources.has(resource_name):
		resources[resource_name]["max"] += new_max
		var resource = main.get_child(resource_keys.find(resource_name))
		var bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar")
		bar.max_value += new_max
		var bar_label = bar.get_child(0)
		bar_label.text = str(bar.value)+'/'+str(bar.max_value)

