extends CharacterBody3D

@export var move_speed: float = 6.0
@export var mouse_sensitivity: float = 0.1
@export var jump_velocity: float = 4.5

var gravity_strength: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D

var yaw_radians: float = 0.0
var pitch_radians: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		yaw_radians -= deg_to_rad(mouse_sensitivity * motion.relative.x)
		pitch_radians -= deg_to_rad(mouse_sensitivity * motion.relative.y)
		pitch_radians = clampf(pitch_radians, deg_to_rad(-88.0), deg_to_rad(88.0))
		rotation.y = yaw_radians
		camera.rotation.x = pitch_radians
	elif event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("interact"):
		var gm := _find_game_manager()
		if gm:
			gm.show_next_paper()

func _physics_process(delta: float) -> void:
	var velocity_vec := velocity

	if not is_on_floor():
		velocity_vec.y -= gravity_strength * delta

	var input_dir := Vector2.ZERO
	input_dir.y -= int(Input.is_action_pressed("move_forward"))
	input_dir.y += int(Input.is_action_pressed("move_back"))
	input_dir.x -= int(Input.is_action_pressed("move_left"))
	input_dir.x += int(Input.is_action_pressed("move_right"))

	var wish_dir := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	velocity_vec.x = wish_dir.x * move_speed
	velocity_vec.z = wish_dir.z * move_speed

	velocity = velocity_vec
	move_and_slide()

func _find_game_manager():
	for node in get_tree().get_nodes_in_group("game_manager"):
		return node
	return null
