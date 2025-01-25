extends Control

@export var label : Label

const MAX_DISPLAYABLE_TIME : float = 300
const EXTRA_TIME : float = 4

var remainingTime : float = MAX_DISPLAYABLE_TIME + EXTRA_TIME

func _ready():
	assert(label != null)

func _process(delta):
	remainingTime = remainingTime - delta
	var displayedTime = min(MAX_DISPLAYABLE_TIME, remainingTime)
	var remainingMinutes = floor(displayedTime / 60)
	var remainingSeconds = floor(displayedTime - 60*remainingMinutes)
	label.text = ("%02d" % remainingMinutes) + ":" + ("%02d" % remainingSeconds)
