extends RigidBody2D

signal killed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LifeTime.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die():
	emit_signal("killed")
	queue_free()


func _on_life_time_timeout():
	queue_free()


func _on_body_entered(body: Node):
	if body.is_in_group("Lasers"):
		die()
