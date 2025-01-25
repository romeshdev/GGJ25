class_name VictoryBehaviour extends Control

func _ready():
	Jukebox.playTitleMusic()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_returnToTitle()

func _returnToTitle():
	var title = load("res://title/RootTitle.tscn").instantiate()
	get_tree().root.add_child(title)
	queue_free()

func _on_button_title_pressed():
	_returnToTitle()
