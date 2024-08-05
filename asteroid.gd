extends Area2D

var speed = 200
var health = 5

func _physics_process(delta):
	position += Vector2(0, speed) * delta
	
	# Check if the asteroid is outside the screen bounds
	if position.y > get_viewport_rect().size.y:
		queue_free()

#func _on_Asteroid_area_entered(area):
	#if area.is_in_group("Bullets"):
		#print("bullets")
		#queue_free()
	#elif area.is_in_group("Ship"):
		#get_tree().change_scene("res://path_to_previous_scene.tscn")



func _on_area_entered(area):
	
	if area.is_in_group("Bullets"):
		health -= 2
		if health <= 0:
			queue_free()

