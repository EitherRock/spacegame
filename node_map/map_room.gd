class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	#Room.Type.MECHANIC: [preload("res://icon_mechanic.svg"), Vector2.ONE],
	#Room.Type.COMBAT: [preload("res://icon_mechanic.svg"), Vector2.ONE],
	Room.Type.MECHANIC: [preload("res://icon_mechanic.svg"), Vector2(0.5, 0.5)],
	Room.Type.COMBAT: [preload("res://icon_mechanic.svg"), Vector2(0.5, 0.5)],
	Room.Type.SHOP: [preload("res://icon_mechanic.svg"), Vector2(0.6, 0.6)],
	Room.Type.BOSS: [preload("res://icon_mechanic.svg"), Vector2(1.25, 1.25)]
}

@onready var sprite_2d: Sprite2D = $visuals/Sprite2D
@onready var line_2d: Line2D = $visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room

#func _ready() -> void:
	#print(line_2d)
	#print(sprite_2d)
	#line_2d.modulate = Color.ALICE_BLUE
	#print(line_2d.modulate)
	#var test_room := Room.new()
	#test_room.type = Room.Type.MECHANIC
	#test_room.position = Vector2(100, 100)
	##room = test_room
	##print(room)
	#
	#await get_tree().create_timer(3).timeout
	#available = true

func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")
		

func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position

	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]
	
func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx:int):
# change for mobile
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	print("Map room pressed")
	room.selected = true
	animation_player.play("select")
	var timer = Timer.new()
	timer.set_wait_time(2)  # Set the timer interval to 1 second
	timer.set_one_shot(false)  # Make the timer repeat
	 # Connect the timer's timeout signal to a method
	timer.connect("timeout", _on_map_room_selected)
	add_child(timer)  # Add the timer as a child of this node
	timer.start() 
	#await timer
	get_tree().change_scene_to_file("res://asteroid_map.tscn")
	
# called by the animation player when the 
func _on_map_room_selected() -> void:
	selected.emit(room)


#func _on_mouse_entered():
	#print("pressed")
	#room.selected = true
	#animation_player.play("select")
