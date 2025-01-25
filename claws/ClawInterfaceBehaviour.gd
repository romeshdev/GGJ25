class_name ClawInterface extends Control

@export var clawContainer : Control
@export var clawPosition : Control
@export var actionLeft : StringName
@export var actionRight : StringName
@export var actionUp : StringName
@export var actionDown : StringName

var input : Vector2

func _ready():
	assert(clawContainer != null)
	assert(clawPosition != null)
	assert(actionLeft != "")
	assert(actionRight != "")
	assert(actionUp != "")
	assert(actionDown != "")

func _process(delta):
	input = Input.get_vector(actionLeft, actionRight, actionUp, actionDown)
	clawPosition.set_position(clawContainer.size * 0.5 * input)
	
