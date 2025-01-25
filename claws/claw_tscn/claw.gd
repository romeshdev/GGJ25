extends Node3D

@export var claw_side = "R":
	set(value):
		claw_side = value

var grip_strenth = .1;
var max_pincer_rotation_degrees = 10
var target_claw: Node3D;

func _ready():
	if(claw_side == "R"):
		$Claw_L_real.hide()
		target_claw = $Claw_R_real/Pincer
	if(claw_side == "L"):
		$Claw_R_real.hide()
		target_claw = $Claw_L_real/Pincer

func _grip_claw(pincer: Node3D):
	if(claw_side == "R"):
		var right_min_rotation = 0
		var right_max_rotation = -25
		var right_claw_str = (-.5 + Input.get_action_strength("crab_right_claw")) * grip_strenth
		#print("Right claw:")
		#print(right_claw_str)
		#print(pincer.rotation_degrees.y)
		var r_fully_opened = pincer.rotation_degrees.y <= right_max_rotation
		var r_fully_closed = pincer.rotation_degrees.y >= right_min_rotation
		if (!r_fully_opened and !r_fully_closed or ((r_fully_opened and right_claw_str > 0) or (r_fully_closed and right_claw_str < 0))):
			pincer.rotate_y(right_claw_str)
			
		var final_r_rotation_y = pincer.rotation_degrees.y
		if(final_r_rotation_y > 0 and final_r_rotation_y > right_min_rotation):
			pincer.rotation_degrees = Vector3(0, right_min_rotation, 0)
			
		if(final_r_rotation_y < 0 and final_r_rotation_y < right_max_rotation):
			pincer.rotation_degrees = Vector3(0, right_max_rotation, 0)
	
	if(claw_side == "L"):
		var left_min_rotation = 0
		var left_max_rotation = 25
		var left_claw_str = (.5 - Input.get_action_strength("crab_left_claw")) * grip_strenth
		#print("Left claw:")
		#print(left_claw_str)
		#print(pincer.rotation_degrees.y)
		var l_fully_opened = pincer.rotation_degrees.y >= left_max_rotation
		var l_fully_closed = pincer.rotation_degrees.y <= left_min_rotation
		if (!l_fully_opened and !l_fully_closed or ((l_fully_opened and left_claw_str < 0) or (l_fully_closed and left_claw_str > 0))):
			pincer.rotate_y(left_claw_str)
		
		var final_l_rotation_y = pincer.rotation_degrees.y
		if(final_l_rotation_y > 0 and final_l_rotation_y > left_max_rotation):
			pincer.rotation_degrees = Vector3(0, left_max_rotation, 0)
			
		if(final_l_rotation_y < 0 and final_l_rotation_y < left_min_rotation):
			pincer.rotation_degrees = Vector3(0, left_min_rotation, 0)

func _physics_process(_delta):
	_grip_claw(target_claw)
