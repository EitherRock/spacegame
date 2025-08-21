extends Control

@export var resource_name: String = "metal"
@export var increment_amount: int = 1
var resource_manager = null

func _ready():
	update_ui()

#func _on_button_pressed():
	#if resource_manager.create_resource(resource_name):
		#update_ui()

func update_ui():
	print(resource_manager)
	#var amount = resource_manager.get_resource_amount(resource_name)
	#$ResourceContainer/ProgressBar.value = amount
	#$ResourceContainer/ProgressBar/Label.text = "%d / %d" % [amount, $ResourceContainer/ProgressBar.max_value]
