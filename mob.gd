extends RigidBody2D
signal killed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	add_to_group("mobs")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	# Check if the body that entered is a laser
	if body.is_in_group("Lasers"):
		die()

func die():
	emit_signal("killed")
	queue_free()
