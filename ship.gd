extends Area2D

var speed = 200  # Speed of movement
var screen_size
var rotaion_speed: int = 1

var bullet_scene = preload("res://bullet.tscn")
var laser_scene = preload("res://weapons/laser_ray.tscn")
var bullet_speed = 500  # Speed of the bullet

var spawn_interval = 1.0

# Create a new Timer instance
var timer = Timer.new()
var bullets: Array
var laser: RayCast2D
var has_laser: bool = true
var has_bullets: bool = false


func _ready():
	# Get the viewport size to determine the screen boundaries
	screen_size = get_viewport().get_visible_rect().size
	
	if has_laser:
		laser = laser_scene.instantiate()
		laser.enabled = true
		print(laser)
		laser.position = position  # Set laser's initial position to the ship's position
		add_child(laser)
		
		var laser_timer = Timer.new()
		laser_timer.wait_time = spawn_interval
		laser_timer.one_shot = false
		laser_timer.connect("timeout", _on_Laser_Timer_timeout)
		add_child(laser_timer)
		laser_timer.start()
	
	
	bullets = []
	# Configure the timer
	if has_bullets:
		timer.set_wait_time(1)  # Set the timer interval to 1 second
		timer.set_one_shot(false)  # Make the timer repeat
		timer.connect("timeout", _on_timer_timeout)  # Connect the timer's timeout signal to a method
		add_child(timer)  # Add the timer as a child of this node
		timer.start()  # Start the timer

func _on_Laser_Timer_timeout():
	pass

func _on_timer_timeout():
	#pass
	 #This method is called every time the timer times out (every 1 second)
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = self.global_position
	bullet.direction = Vector2(0, -1)
	bullets.append(bullet)
	get_parent().add_child(bullet)
	


func _physics_process(delta):
	var velocity = Vector2()

	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	#if Input.is_action_pressed('ui_up'):
		#rotation += rotaion_speed * delta
	#
	#if Input.is_action_pressed("ui_down"):
		#rotation -= rotaion_speed * delta

	velocity = velocity.normalized() * speed

	position += velocity * delta
	
	# Clamp the ship's position to keep it within the screen boundaries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if has_laser:
		laser.global_position = position
	#print(laser.position)


func _on_area_entered(area):
	if area.is_in_group("Asteroid"):
		print(len(get_tree().get_nodes_in_group("Asteroids")))
		for asteroid in get_tree().get_nodes_in_group("Asteroids"):
			asteroid.queue_free()
		print('Ship')
		self.call_deferred('change_scene')

func change_scene():
	get_tree().change_scene_to_file("res://main.tscn")
		
