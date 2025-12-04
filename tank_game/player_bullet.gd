extends Area3D

const SPEED = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3 (0, 0, SPEED) * delta


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") && body.has_method("got_hit"):
		body.got_hit()
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
