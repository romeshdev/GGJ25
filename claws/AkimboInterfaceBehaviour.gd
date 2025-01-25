class_name AkimboInterface extends Control

##############################
# CONSTANTS
##############################

const ROTATION_DEAD_ZONE : float = 0.15
const MOVEMENT_DEAD_ZONE : float = 0.15


##############################
# EXPOSED IN INSPECTOR
##############################

@export var leftClaw : ClawInterface
@export var rightClaw : ClawInterface 


##############################
# PUBLIC ATTRIBUTES
##############################

var leftClawPosition : Vector2
var rightClawPosition : Vector2
var rotation_axis : float
var movement_axis : float

##############################
# PUBLIC INTERFACE
##############################


##############################
# PRIVATE SUBROUTINES
##############################


##############################
# GODOT CALLBACKS
##############################

func _ready():
	assert(leftClaw != null)
	assert(rightClaw != null)

func _process(_delta):
	# Save claw positions
	leftClawPosition = leftClaw.input
	rightClawPosition = rightClaw.input
	
	# Parse rotation
	rotation_axis = (leftClawPosition.y - rightClawPosition.y) / 2
	rotation_axis = rotation_axis*rotation_axis*rotation_axis
	if abs(rotation_axis) < ROTATION_DEAD_ZONE:
		rotation_axis = 0
		
	# Parse advance / retreat
	var movement_intensity : float = leftClawPosition.y * rightClawPosition.y
	if movement_intensity >= MOVEMENT_DEAD_ZONE:
		movement_axis = movement_intensity * sign(leftClaw.input.y)
	else:
		movement_axis = 0
