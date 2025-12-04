extends CharacterBody3D

var health = 3
var speed = 5.0

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var marker_3d: Marker3D = $Head/Barrel/Marker3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var head: MeshInstance3D = $Head
@onready var hit_fx: CPUParticles3D = $Hit
@onready var disabled_fx: CPUParticles3D = $Disabled
@onready var timer: Timer = $Timer
@onready var Health_Bar: Sprite3D = $Sprite3D
@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar

const ENEMY_BULLET = preload("uid://bpsvcelxua5ie")

enum State_Machine {Patrol, Chase, Shoot, Disabled}
var States:State_Machine = State_Machine.Patrol

var patrol_point: PathFollow3D
func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	velocity = Vector3.ZERO
	progress_bar.value = health
	match States:
		State_Machine.Patrol:
			Health_Bar.visible = false
			velocity = (patrol_point.global_position - global_transform.origin).normalized() * speed
			head.look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			move_and_slide()
		State_Machine.Chase:
			Health_Bar.visible = true
			navigation.set_target_position(player.global_transform.origin)
			var next_nav_point = navigation.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			head.look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			Health_Bar.look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			move_and_slide()
		State_Machine.Shoot:
			Health_Bar.visible = true
			navigation.set_target_position(player.global_transform.origin)
			var next_nav_point = navigation.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			Health_Bar.look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			head.look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z))
			if timer.is_stopped():
				var instance = ENEMY_BULLET.instantiate()
				instance.position = marker_3d.global_position
				instance.transform.basis = marker_3d.global_transform.basis
				get_parent().add_child(instance)
				timer.start()
		State_Machine.Disabled:
			Health_Bar.visible = false
			disabled_fx.emitting = true
			process_mode = Node.PROCESS_MODE_DISABLED
			



func got_hit():
	hit_fx.emitting = true
	health -= 1
	if health <= 0:
		States = State_Machine.Disabled


func _on_player_detected_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and States != State_Machine.Disabled:
		States = State_Machine.Chase


func _on_player_detected_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and States != State_Machine.Disabled:
		States = State_Machine.Patrol


func _on_player_nearby_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and States != State_Machine.Disabled:
		States = State_Machine.Shoot


func _on_player_nearby_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and States != State_Machine.Disabled:
		States = State_Machine.Chase

func die():
	pass
