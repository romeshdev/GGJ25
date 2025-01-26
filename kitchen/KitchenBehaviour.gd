extends Node3D

signal crabInPot
signal eggInPot

func _on_pot_crab_in_pot():
	crabInPot.emit()

func _on_pot_egg_in_pot():
	eggInPot.emit()
