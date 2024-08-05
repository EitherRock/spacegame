extends Control

var screen_size
var asteroid_scene = preload("res://asteroid.tscn")
var spawn_interval = 1.0
var min_speed = 100
var max_speed = 300
var ship_lives 

# Called when the node enters the scene tree for the first time.
func _ready():
	var asteroid_timer = Timer.new()
	asteroid_timer.wait_time = spawn_interval
	asteroid_timer.one_shot = false
	asteroid_timer.connect("timeout", _on_Asteroid_Timer_timeout)
	add_child(asteroid_timer)
	asteroid_timer.start()
	

func _on_Asteroid_Timer_timeout():
	var asteroid = asteroid_scene.instantiate()
	
	# Add a random speed to the asteroid
	var speed = randf_range(min_speed, max_speed)
	asteroid.set("speed", speed)
	
	asteroid.global_position = Vector2(randf_range(0, get_viewport().size.x), 0)
	get_parent().add_child(asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
