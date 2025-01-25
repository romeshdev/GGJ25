extends Control

@export var label : Label

const MAX_DISPLAYABLE_TIME : float = 300
const EXTRA_TIME : float = 4

signal timeout

var remainingTime : float = MAX_DISPLAYABLE_TIME + EXTRA_TIME

func _ready():
	assert(label != null)

func _process(delta):
	# Countdown
	remainingTime = remainingTime - delta
	if remainingTime <= 0:
		remainingTime = 0
		timeout.emit()
	
	# Display remaining time
	var displayedTime = min(MAX_DISPLAYABLE_TIME, remainingTime)
	var remainingMinutes = floor(displayedTime / 60)
	var remainingSeconds = floor(displayedTime - 60*remainingMinutes)
	label.text = ("%02d" % remainingMinutes) + ":" + ("%02d" % remainingSeconds)
