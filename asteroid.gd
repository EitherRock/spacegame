extends Area2D

var speed = 200
@export var health = 100

func _physics_process(delta):
	position += Vector2(0, speed) * delta
	
	# Check if the asteroid is outside the screen bounds
	if position.y > get_viewport_rect().size.y:
		queue_free()
	
	if health <= 0:
		print("asteroidn bye bye")
		queue_free()
	
	
	


func _on_area_entered(area):
	
	if area.is_in_group("Bullets"):
		health -= 2
		if health <= 0:
			queue_free()
	
	if area.is_in_group("Laser"):
		print(true)

func apply_damage(amount):
	print("applying damage through the asteroid")
	print(amount)
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
