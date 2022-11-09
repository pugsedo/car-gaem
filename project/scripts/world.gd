extends Node2D

onready var player1: KinematicBody2D = $Player1
onready var player2: KinematicBody2D = $Player2

var restart_avaible: bool = true

func race_started():
	player1.can_move = true
	player2.can_move = true
func _ready():
	Gui.hud.connect("race_started", self, "race_started")
	player1.can_move = false
	player2.can_move = false
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if restart_avaible:
			restart_avaible = false
			player1.restart()
			player2.restart()
			Gui.hud.start_count_down()

func _on_FinishLine_body_entered(body: KinematicBody2D):
	if body != null and body.is_in_group('race_car'):
		Gui.hud.finish_race(body.name + ' wins!')
		player1.can_move = false
		player2.can_move = false
		restart_avaible = true


func _camera_anim():
	pass # Replace with function body.
