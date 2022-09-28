extends CanvasLayer

signal race_started

onready var timer: Timer = $Timer
onready var counter: Timer = $Counter

onready var count_down_text: Label = $CountDownText
onready var timer_text: Label = $TimerText
onready var info_text: Label = $InfoText

var count_down: int = 3
var time_taken: int = 0

func _ready():
	info_text.text = 'Press space to start, WASD and Arrow Keys to move'
	
	count_down_text.visible = false
	timer_text.visible = false
	info_text.visible = true
func start_count_down():
	count_down = 3
	time_taken = 0
	
	count_down_text.text = str(count_down)
	
	timer_text.visible = false
	info_text.visible = false
	count_down_text.visible = true
	
	timer.start()
func finish_race(text):
	info_text.text = 'Press space to restart'
	count_down_text.text = 'Finish!\n' + text
	count_down_text.visible = true
	timer_text.visible = true
	counter.stop()
	
	info_text.visible = true

func _on_Timer_timeout():
	if count_down < 0:
		count_down_text.visible = false
		timer_text.visible = true
		timer.stop()
	if count_down > 0:
		count_down_text.text = str(count_down)
	else:
		count_down_text.text = 'GO!'
		emit_signal("race_started")
		counter.start()
	
	count_down -= 1

func _on_Counter_timeout():
	time_taken += 1
	timer_text.text = str(time_taken)
