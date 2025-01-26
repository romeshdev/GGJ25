extends Node3D

@export var offset: float = 20.0

var parent: CharacterBody3D
var previous_position

func _ready():
	parent = get_parent_node_3d()
	previous_position = parent.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = parent.global_position - previous_position
	global_position = parent.global_position + velocity * offset
	
	previous_position = parent.global_position
