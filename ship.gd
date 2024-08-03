extends Area2D

var speed = 200  # Speed of movement

var bullet_scene = preload("res://bullet.tscn")
var bullet_speed = 500  # Speed of the bullet

var asteroid_scene = preload("res://asteroid.tscn")
var spawn_interval = 1.0

# Create a new Timer instance
var timer = Timer.new()
var bullets: Array

func _ready():
	var asteroid_timer = Timer.new()
	asteroid_timer.wait_time = spawn_interval
	asteroid_timer.one_shot = false
	asteroid_timer.connect("timeout", _on_Asteroid_Timer_timeout)
	add_child(asteroid_timer)
	asteroid_timer.start()
	
	bullets = []
	# Configure the timer
	timer.set_wait_time(1)  # Set the timer interval to 1 second
	timer.set_one_shot(false)  # Make the timer repeat
	timer.connect("timeout", _on_timer_timeout)  # Connect the timer's timeout signal to a method
	add_child(timer)  # Add the timer as a child of this node
	timer.start()  # Start the timer

func _on_timer_timeout():

	# This method is called every time the timer times out (every 1 second)
	var bullet = bullet_scene.instantiate()
	bullet.global_position = self.global_position
	bullets.append(bullet)
	#bullet.position = self.position
	#bullet.linear_velocity = Vector2(0, -bullet_speed)
	get_parent().add_child(bullet)
	
	
func _on_Asteroid_Timer_timeout():
	var asteroid = asteroid_scene.instantiate()
	
	asteroid.global_position = Vector2(randf_range(0, get_viewport().size.x), 0)
	get_parent().add_child(asteroid)

func _physics_process(delta):
	var velocity = Vector2()

	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1

	velocity = velocity.normalized() * speed

	position += velocity * delta


func _on_area_entered(area):
	if area.is_in_group("Asteroid"):
		for asteroid in get_tree().get_nodes_in_group("Asteroids"):
			asteroid.queue_free()
		print('Ship')
		get_tree().change_scene_to_file("res://main.tscn")
		
