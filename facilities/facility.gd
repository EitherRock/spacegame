class_name Facility
extends Control

#enum Type {RESEARCH, MINE, ARMORY}

signal resource_added(resource_node: Control)
signal resource_removed(resource_node: Control)

@onready var label: Label = $Panel/MarginContainer/VBoxContainer/Label
@export var facility_name := "Unnamed Facility"
@export var icon: Texture2D
@export var allowed_resources: Array[String] = []

var _view_width: float
var _resource_nodes := {}

func _ready():
	assert(label != null, "Label node not found! Check scene structure")
	print("Facility script loaded successfully for: ", facility_name)
	_view_width = get_viewport_rect().size.x
	
func add_resource(resource_key: String, resource_scene: PackedScene) -> bool:
	if not can_add_resource(resource_key): 
		return false
	
	var new_resource = resource_scene.instantiate()
	#ResourceManager.setup_resource_ui(new_resource, resource_key)
	_resource_nodes[resource_key] = new_resource
	add_child(new_resource)
	
	#print('getting x size')
	#print(get_viewport_rect().size.x)
	
	# Position the new resource (customize as needed)
	#new_resource.position = Vector2(
		#randf_range(-50, 50),
		#randf_range(-50, 50)
	#)
	
	resource_added.emit(new_resource)
	return true

func postion_resources() -> void:
	var resourses_len = _resource_nodes.size()
	var spaces_between = _view_width / resourses_len
	var position_start = 0
	
	for resource in _resource_nodes:
		_resource_nodes[resource].position = Vector2(position_start, 1500)
		position_start += spaces_between
	print('spaces between ', spaces_between)

func remove_resource(resource_key: String) -> void:
	if not _resource_nodes.has(resource_key): return
	
	var node = _resource_nodes[resource_key]
	remove_child(node)
	node.queue_free()
	_resource_nodes.erase(resource_key)
	resource_removed.emit(node)


func can_add_resource(resource_key: String) -> bool:
	return (allowed_resources.has(resource_key) and 
			not _resource_nodes.has(resource_key))
