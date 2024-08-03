class_name MapGenerator
extends Node

const X_DIST := 100
const Y_DIST := 75
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 14
const MAP_WIDTH := 6
const PATHS := 5
const COMBAT_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEGHT := 2.5
const MECHANIC_ROOM_WEIGHT := 4.0

var random_room_type_weights = {
	Room.Type.COMBAT: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.MECHANIC: 0.0
}

var random_room_type_total_weight := 0
var map_data: Array[Array]

#func _ready() -> void:
	#generate_map()

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	#var i := 0
	#for floor in map_data:
		#print("floor %s" % i)
		#var used_rooms = floor.filter(
			#func(room: Room): return room.next_rooms.size() > 0
		#)
		#print(used_rooms)
		#i += 1
	
	return map_data
	

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room]=[]
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			# boss room has a non-random Y
			if i == FLOORS - 1:
				current_room.position.y	= (i+1) * -Y_DIST
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
				
			y_coordinates.append(starting_point)
			
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
		
	current_room.next_rooms.append(next_room)
	
	return next_room.column
	

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbor: Room
	var right_neighbor: Room
	
	# if j == 0, there's no left neighbor
	if j > 0:
		left_neighbor = map_data[i][j - 1]
		
	if j < MAP_WIDTH - 1:
		right_neighbor = map_data[i][j + 1]
		
	if right_neighbor and room.column > j:
		for next_room: Room in right_neighbor.next_rooms:
			if next_room.column < room.column:
				return true
	
	if left_neighbor and room.column < j:
		for next_room: Room in left_neighbor.next_rooms:
			if next_room.column > room.column:
				return true
	
	return false
	

func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room
	
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
	
	boss_room.type = Room.Type.BOSS

func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.COMBAT] = COMBAT_ROOM_WEIGHT
	random_room_type_weights[Room.Type.MECHANIC] = COMBAT_ROOM_WEIGHT + MECHANIC_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = COMBAT_ROOM_WEIGHT + MECHANIC_ROOM_WEIGHT + SHOP_ROOM_WEGHT
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.SHOP]

func _setup_room_types() -> void:
	# first floor should be non combat but setting to combat for faster game developemnt and testing. 
	#Shoudl change in the future
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.COMBAT
			
	
	#9th floor is always treasure or upgrade
	for room: Room in map_data[8]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MECHANIC
			
	# last floor before a boss is always a mechanic
	for room: Room in map_data[13]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MECHANIC
	
	#rest of rooms
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room_to_set: Room) -> void:
	var mechanic_below_4 := true
	var consecutive_mechanic := true
	var consecutive_shop := true
	var mechanic_on_13 := true
	
	var type_candidate: Room.Type
	
	while mechanic_below_4 or consecutive_mechanic or consecutive_shop or mechanic_on_13:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_mechanic := type_candidate == Room.Type.MECHANIC
		var has_mechanic_parent := _room_has_parent_of_type(room_to_set, Room.Type.MECHANIC)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)
		
		mechanic_below_4 = is_mechanic and room_to_set.row < 3
		consecutive_mechanic = is_mechanic and has_mechanic_parent
		consecutive_shop = is_shop and has_shop_parent
		mechanic_on_13 = is_mechanic and room_to_set.row == 12
		
	room_to_set.type = type_candidate
	
	
func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	# left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# below
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# right
	if room.column < MAP_WIDTH - 1  and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false
	
			
			
func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.COMBAT
