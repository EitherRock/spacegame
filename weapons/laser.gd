extends RayCast2D

var is_casting := false : set = set_is_casting
#var available := false : set = set_available


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.is_casting = event.pressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var cast_point := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	$Line2D.points[1] = cast_point
	

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$CastingParticle.emitting = is_casting
	if is_casting:
		appear()
	else:
		disappear()
	set_physics_process(is_casting)

func appear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 10, 0.2)

func disappear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 0, 0.2)

	
