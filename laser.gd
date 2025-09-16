extends Area2D

signal shot
var speed = 400
var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Lasers")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	if position.x < 0 or position.y < 0 or position.x > 2000 or position.y > 2000:
		queue_free()


func _on_body_entered(body: Node2D) :
	if body.is_in_group("mobs"):
		body.die()
	queue_free()
