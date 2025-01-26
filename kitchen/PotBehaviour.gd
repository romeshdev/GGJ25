class_name PotBehaviour extends Node3D

signal eggInPot
signal crabInPot

var gameEnding : bool = false
var isDefeat : bool = false
var timer : float = -1

func _ready():
	pass
	
func _process(delta):
	# Countdown timer
	if timer < 0:
		return
	timer = timer - delta
	if timer <= 0:
		timer = -1
		if isDefeat:
			crabInPot.emit()
		else:
			eggInPot.emit()

func _on_pot_water_body_entered(body):
	if body is CrabBehaviour:
		isDefeat = true
		timer = 2
	if body is EggBehaviour:
		timer = 2

func _on_pot_water_body_exited(body):
	pass
