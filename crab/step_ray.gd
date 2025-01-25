extends RayCast3D

@export var step_target: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var hit_point = get_collision_point()
	if hit_point:
		step_target.global_position = hit_point
