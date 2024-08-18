extends RayCast2D

var is_casting := self.enabled
@export var damage: int = 1
var damage_timer = null
#var collider = null
#var is_casting := false : set = set_is_casting
#var available := false : set = set_available


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true) # started as false
	$Line2D.points[1] = Vector2.ZERO
	
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#print("laser time")
		#self.is_casting = event.pressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	set_physics_process(is_casting)
	var cast_point := target_position
	var collider = null
	force_raycast_update()
	
	$BeamParticle.emitting = is_casting
	$CastingParticle.emitting = is_casting
	if is_casting:
		appear()
		$CollisionParticle.emitting = is_colliding()
	else:
		$CollisionParticle.emitting = false
		disappear()
		if damage_timer:
			damage_timer.stop()
	
	if is_colliding():
		var new_collider = get_collider()
		if collider != new_collider:
			collider = new_collider
			if damage_timer:
				damage_timer.stop()
			damage_timer = Timer.new()
			damage_timer.wait_time = .75
			await damage_timer
			if collider and collider.is_inside_tree():
		
				if collider.has_method("apply_damage"):
					collider.apply_damage(damage)
					print("Collider Health: %s" % str(collider.health))
				else:
					print("Collider does not have 'apply_damage' method")
			else:
				print("Collider is no longer valid")
			#damage_timer.connect("timeout", _apply_damage)
			add_child(damage_timer)
			damage_timer.start()
			print("timeer started")
		cast_point = to_local(get_collision_point())
		$CollisionParticle.global_rotation = get_collision_normal().angle()
		$CollisionParticle.position = cast_point
	else:
		collider = null
		if damage_timer:
			damage_timer.stop()
			print("Timer stopped")
			damage_timer = null
			
		
	$Line2D.points[1] = cast_point
	$BeamParticle.position = cast_point * 0.5
	$BeamParticle.process_material.emission_box_extents.y = cast_point.length() * 0.5
	

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$BeamParticle.emitting = is_casting
	$CastingParticle.emitting = is_casting
	if is_casting:
		appear()
	else:
		$CollisionParticle.emitting = false
		disappear()
	set_physics_process(is_casting)

func appear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 10, 0.2)

func disappear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 0, 0.2)

func do_damage(health) -> int:
	print(health)
	
	while health > 0:
		await get_tree().create_timer(1.0).timeout
		health -= damage
		
	
	print("health")
	print(health)
	return health


#func _apply_damage():
	#print("apply dmg")
	#if collider and collider.is_inside_tree():
		#
		#if collider.has_method("apply_damage"):
			#collider.apply_damage(damage)
			#print("Collider Health: %s" % str(collider.health))
		#else:
			#print("Collider does not have 'apply_damage' method")
	#else:
		#print("Collider is no longer valid")

	
