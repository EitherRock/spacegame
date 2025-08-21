extends Area2D

var direction: Vector2
var speed = 300.0
var timer = Timer.new()

func _process(delta):
	#timer.set_wait_time(1)  # Set the timer interval to 1 second
	#timer.set_one_shot(false)  # Make the timer repeat
#
	#add_child(timer)  # Add the timer as a child of this node
	#timer.start()  # Start the timer
	self.position = self.position + speed * direction * delta

func _on_area_entered(area):
	
	if area.is_in_group("Asteroid"):
		queue_free()
