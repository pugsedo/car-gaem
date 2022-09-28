extends Camera2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

func _zoom_in():
	anim_player.play("zoom_in")
func _zoom_out():
	anim_player.play("zoom_in")
func _camera_anim(anim: String):
	anim_player.play(anim)


func _on_Car_camera_anim():
	pass # Replace with function body.
