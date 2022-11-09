extends KinematicBody2D

signal camera_anim

onready var particles: CPUParticles2D = $Particles2D
onready var drift_particles: CPUParticles2D = $DriftParticles

onready var spawn_pos: Vector2 = global_position
onready var spawn_rot: float = rotation

export(bool) var can_move: bool = false
export(float) var speed: float = 200

export var controls: Resource = null

var direction: Vector2 = Vector2.ZERO

var vel_max: float = 2
var vel: float = 0

var steer_speed: float = 2
var current_steer: float = 0
var steer: float = rotation

var drift: float = 0
var drift_boost: float = 0

func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null
func restart():
	global_position = spawn_pos
	rotation = spawn_rot
	
	steer_speed = 2
	current_steer = 0
	steer = rotation * steer_speed

	drift = 0
	drift_boost = 0
func _ready():
	steer = rotation * steer_speed
func _process(delta):
	var add_vel = 0
	
	if can_move:
		add_vel = Input.get_action_strength(controls.move_forward) - Input.get_action_strength(controls.brake)
	
	if add_vel == 0:
		add_vel = -0.01
	if drift_boost > 0:
		drift_boost -= 0.01
	
	vel += add_vel
	
	if vel < 0 and vel != 0:
		vel = 0
#		if particles.emitting == true:
#			emit_signal("camera_anim", "zoom_in")
		particles.emitting = false
	if vel > 0 and particles.emitting == false:
		particles.emitting = true
#		emit_signal("camera_anim", "zoom_out")
	if drift_boost < 0:
		drift_boost = 0
	
	var add_steer = (Input.get_action_strength(controls.steer_right) - Input.get_action_strength(controls.steer_left)) * vel * delta
	current_steer += add_steer
	steer += add_steer
	
	if add_steer == 0:
		current_steer = 0
	if vel > vel_max + drift_boost:
		vel = vel_max + drift_boost
	
	if abs(current_steer) > 2.5 and drift == 0:
		drift = 1.5
		drift_particles.emitting = true
	if abs(current_steer) < 1 and drift > 0:
		drift_boost = drift
		drift = 0
		vel += drift
		drift_particles.emitting = false
func _physics_process(delta):
	rotation = steer / steer_speed
	direction = Vector2(cos(steer / steer_speed), sin(steer / steer_speed))
	move_and_slide(direction * vel * speed, Vector2.UP)
