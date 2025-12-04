extends Node3D

@onready var path_follow_3d_1: PathFollow3D = $NavigationRegion3D/Path3D/PathFollow3D1
@onready var path_follow_3d_2: PathFollow3D = $NavigationRegion3D/Path3D2/PathFollow3D2
@onready var path_follow_3d_3: PathFollow3D = $NavigationRegion3D/Path3D3/PathFollow3D3
@onready var enemy_tank_1: CharacterBody3D = $"Enemy Tank"
@onready var enemy_tank_2: CharacterBody3D = $"Enemy Tank2"
@onready var enemy_tank_3: CharacterBody3D = $"Enemy Tank3"
@onready var player = get_tree().get_first_node_in_group("Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_tank_1.patrol_point = path_follow_3d_1
	enemy_tank_2.patrol_point = path_follow_3d_2
	enemy_tank_3.patrol_point = path_follow_3d_3
	path_follow_3d_1.progress_ratio = 0.0
	path_follow_3d_2.progress_ratio = 0.0
	path_follow_3d_3.progress_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_3d_1.progress_ratio += 0.01 * enemy_tank_1.speed * delta
	path_follow_3d_2.progress_ratio += 0.01 * enemy_tank_2.speed * delta
	path_follow_3d_3.progress_ratio += 0.01 * enemy_tank_3.speed * delta
	if player.health == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
