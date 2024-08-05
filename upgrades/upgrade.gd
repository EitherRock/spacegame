class_name Upgrade
extends Node

enum Type {LASER}

@export var type: Type
@export var damage: float
@export var cooldown: float
@export var production_time: float
@export var unlocled := false
@export var level: int
@export var description: String


func _to_string() :
	pass
	#return "%s (%s)" % [column, Type.keys()[type][0]]
