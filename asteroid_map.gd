extends Control

var asteroid_scene = preload("res://asteroid.tscn")
var spawn_interval = 1.0
var min_speed = 100
var max_speed = 300
var ship_lives = 1

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
	
	# Get ACTUAL visible area accounting for stretch
	var viewport = get_viewport()
	var screen_size = viewport.get_visible_rect().size
	
	# Calculate spawn boundaries (20% outside viewport)
	var spawn_margin = screen_size.x * 0.2
	var left_bound = -spawn_margin
	var right_bound = screen_size.x + spawn_margin
	
	# Set random position (global coords)
	asteroid.global_position = Vector2(
		randf_range(left_bound, right_bound),
		-randf_range(50, 150)  # Above top edge
	)
	
	get_parent().add_child(asteroid)
	
