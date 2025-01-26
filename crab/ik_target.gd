extends Marker3D

@export var step_target: Node3D
@export var step_distance: float = 10.0
@export var fast_step_distance: float = 20.0

@export var adjacent_target: Node3D
@export var character: CharacterBody3D
var previous_position

func _ready():
	previous_position = character.global_position

var is_stepping := false

func _process(delta):
	var character_velocity = character.global_position - previous_position
	var vel = sqrt(character_velocity.length_squared())
	var current_step_distance = step_distance if vel < 8 else (fast_step_distance)
	
	if !is_stepping && !adjacent_target.is_stepping && abs(global_position.distance_to(step_target.global_position)) > (current_step_distance):
		step()
		
func step():
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false)
	previous_position = character.global_position
