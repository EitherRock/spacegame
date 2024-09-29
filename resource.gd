extends Control


@export var increment_amount: int = 1
@export var resource_type: String = "resource"
@export var linked_scene: Node
var resources = { "resource": 0 }
var label_text = null
var bar = null


func _ready():
	pass
# Called when the node enters the scene tree for the first time.
func _on_progress_bar_ready():
	bar = $ResourceContainer/ProgressBar
	label_text = bar.get_node("Label")
	label_text.text = str(bar.value) + " / " + str(bar.max_value)
	
# Function to handle the button press
func _on_button_pressed():
	var prog_value = bar.value
	var thumbs_up = 2
	
	if prog_value + increment_amount <= bar.max_value:
		prog_value += increment_amount
		bar.value = prog_value
		resources[resource_type] += increment_amount
		label_text.text = str(bar.value) + " / " + str(bar.max_value)
	else:
		# Set the progress bar to the maximum value if it exceeds
		resources[resource_type] += bar.max_value - prog_value
		bar.value = bar.max_value
	# Print the current resources and the maximum value of the progress bar
	print("Resource type: %s" % resource_type)
	print("Current resource value: %d" % resources[resource_type])
	print("Max progress bar value: %d" % bar.max_value)
