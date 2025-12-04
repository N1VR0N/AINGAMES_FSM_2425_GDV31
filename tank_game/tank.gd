extends CharacterBody3D

var health = 5
const SPEED = 10.0

const PLAYER_BULLET = preload("uid://r30uuqs7whvj")

@onready var marker_3d: Marker3D = $Head/Barrel/Marker3D
@onready var fira_rate: Timer = $"Fira Rate"
@onready var health_bar: ProgressBar = $Health_Bar
@onready var fira_rate_bar: ProgressBar = $"Fira rate bar"
@onready var hit: CPUParticles3D = $Hit
@onready var disabled: CPUParticles3D = $Disabled

func _physics_process(delta: float) -> void:
	# Add the gravity.
	health_bar.value = health
	fira_rate_bar.value = fira_rate.time_left
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if Input.is_action_pressed("up"):
		var forwardVector = -Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -forwardVector * SPEED
	if Input.is_action_just_released("up"):
		velocity.x = 0
		velocity.z = 0
	if Input.is_action_pressed("down"):
		var backwardVector = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -backwardVector * SPEED
	if Input.is_action_just_released("down"):
		velocity.x = 0
		velocity.z = 0
	if Input.is_action_pressed("left"):
		rotation.y += rad_to_deg(0.0003)
	if Input.is_action_just_released("left"):
		rotation.y += rad_to_deg(0)
	if Input.is_action_pressed("right"):
		rotation.y += rad_to_deg(-0.0003)
	if Input.is_action_just_released("right"):
		rotation.y += rad_to_deg(0)
	if Input.is_action_pressed("shoot") and fira_rate.is_stopped():
		var instance = PLAYER_BULLET.instantiate()
		instance.position = marker_3d.global_position
		instance.transform.basis = marker_3d.global_transform.basis
		get_parent().add_child(instance)
		fira_rate.start()
	if health <= 0:
		disabled.emitting = true
		process_mode = Node.PROCESS_MODE_DISABLED
	move_and_slide()

func got_hit():
	health -= 1
	hit.emitting = true
	
