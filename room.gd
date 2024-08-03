class_name Room
extends Node


enum Type {NOT_ASSIGNED, MECHANIC, ANOMOLY, QUEST, MINING, SHOP, COMBAT, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false

func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
