class_name PotBehaviour extends Node3D

signal eggInPot
signal crabInPot

func _ready():
	pass
	
func _process(delta):
	pass

func _on_pot_water_body_entered(body):
	if body is CrabBehaviour:
		print("Crab in pot!")
		crabInPot.emit()
	if body is EggBehaviour:
		print("Egg in pot!")
		eggInPot.emit()

func _on_pot_water_body_exited(body):
	pass
