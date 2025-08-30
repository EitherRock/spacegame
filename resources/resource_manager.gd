extends Node

@export var resources = ResourceValues.resources
var facility = null
var resource_keys = null
var resource_ui_elements = {}

func initialize():
	facility = $"../../../.."
	var resource_nodes = facility._resource_nodes

	if resources:
		resource_keys = resources.keys()
		for resource_name in resource_nodes:
			var control = resource_nodes[resource_name]

			if not control is Control:
				continue
			
			print("Processing resource: ", resource_name)
			
			if not resource_name in resource_keys:
				print("No matching resource key for: ", resource_name)
				continue
			
			setup_resource_ui(control, resource_name)

func setup_resource_ui(resource: Control, resource_name: String):
	var c_button = resource.get_node("MarginContainer/ResourceContainer/ResourceCreateButton")
	var c_upgrade_button = resource.get_node("MarginContainer/ResourceContainer/UpgradeButton")
	var progress_bar = resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar")

	# Store UI references
	resource_ui_elements[resource_name] = {
		"button": c_button,
		"progress_bar": progress_bar,
		"progress_label": progress_bar.get_node("Label"),
		"sub_bar": resource.get_node("MarginContainer/ResourceContainer/VBoxContainer/ProgressBar2")
	}
	
	# Initialize UI
	update_resource_display(resource_name)

	c_button.text = resource_name
	c_button.rotation = 90
	
	# Disconnect existing signals to prevent duplicates
	if c_button.pressed.is_connected(generate_resource.bind(resource_name)):
		c_button.pressed.disconnect(generate_resource.bind(resource_name))
	if c_upgrade_button.pressed.is_connected(update_resource_max.bind(resource_name, 10)):
		c_upgrade_button.pressed.disconnect(update_resource_max.bind(resource_name, 10))
	
	# Connect signals
	c_button.pressed.connect(generate_resource.bind(resource_name))
	c_upgrade_button.pressed.connect(update_resource_max.bind(resource_name, 10))

	# Initial button state
	c_button.disabled = !can_create(resource_name)

func generate_resource(resource_name):
	var ui = resource_ui_elements.get(resource_name)
	if not ui:
		return
	
	if can_create(resource_name):
		ui.button.disabled = true

		# Animate production
		var tween = get_tree().create_tween()
		tween.tween_property(ui.sub_bar, "value", 100, 1)
		#tween.tween_property(ui.sub_bar, "value", 100, 9)

		tween.tween_property(ui.sub_bar, "value", 0, 0)

		await tween.finished

		if create_resource(resource_name):
			print('created resource: ', resource_name)
			update_resource_display(resource_name)
			update_dependent_resources(resource_name)
		
		

func update_resource_display(resource_name: String):
	var ui = resource_ui_elements.get(resource_name)
	if ui:
		ui.progress_bar.value = get_resource_amount(resource_name)
		ui.progress_bar.max_value = get_resource_max(resource_name)
		ui.progress_label.text = "%d/%d" % [ui.progress_bar.value, ui.progress_bar.max_value]
		ui.button.disabled = !can_create(resource_name)

func update_dependent_resources(resource_name: String):
	# Update all resources that depend on this one
	for dependent_name in resources:
		var dependencies = resources[dependent_name].get("dependencies", {})
		
		if resource_name in dependencies:
			print("Updating dependent resource: ", dependent_name)
			
			# Get the UI elements if they exist
			if resource_ui_elements.has(dependent_name):
				var ui = resource_ui_elements[dependent_name]
				ui.button.disabled = !can_create(dependent_name)


func add_resource(resource_name: String, amount: int) -> void:
	if resources.has(resource_name):
		resources[resource_name]["amount"] += amount

func can_create(resource_name: String) -> bool:
	print("can create", resource_name)
	if not resources.has(resource_name):
		print('false ', facility.facility_name)
		return false
		
	if resources[resource_name]["amount"] >= resources[resource_name]["max"]:
		return false
		
	for dependency in resources[resource_name]["dependencies"]:
		if get_resource_amount(dependency) < resources[resource_name]["dependencies"][dependency]:
			return false
	return true
	
func create_resource(resource_name: String) -> bool:
	if can_create(resource_name):
		# Deduct dependencies
		for dependency in resources[resource_name]["dependencies"]:
			print('dependencies for resouce', dependency)
			resources[dependency]["amount"] -= resources[resource_name]["dependencies"][dependency]
			update_resource_display(dependency)  # Update dependency UI
			
			
		# Create the resource
		if resources[resource_name]['amount'] < resources[resource_name]['max']:
			add_resource(resource_name, 1)
			return true
	return false

func update_resource_max(resource_name: String, new_max: int) -> void:
	if resources.has(resource_name):
		resources[resource_name]["max"] += new_max
		update_resource_display(resource_name)

func get_resource_amount(resource_name: String) -> int:
	if resources.has(resource_name):
		print("resource amount ", resource_name)
		return resources[resource_name]["amount"]
	return 0

func get_resource_max(resource_name: String) -> int:
	if resources.has(resource_name):
		return resources[resource_name]["max"]
	return 0
