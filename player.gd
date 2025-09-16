extends Area2D


signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var LaserScene: PackedScene
var screen_size # Size of the game window.

enum WeaponType { NORMAL, SHOTGUN }

var weapon_type = WeaponType.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	weapon_type = WeaponType.NORMAL
	hide()

var facing_direction = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if Input.is_action_just_pressed("shoot_action"):
		shoot_laser()
	if velocity.length() > 0:
		facing_direction = velocity.normalized()  # store the direction player is moving
		velocity = velocity.normalized() * speed

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "fly_side"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "fly_up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	weapon_type = WeaponType.NORMAL
	show()
	$CollisionShape2D.disabled = false
	

func shoot_laser():
	
	match weapon_type:
		WeaponType.NORMAL:
			var laser = LaserScene.instantiate()
			laser.position = position
			laser.direction = facing_direction
			laser.rotation = laser.direction.angle()
			get_parent().add_child(laser)
		
		WeaponType.SHOTGUN:
			var spread = deg_to_rad(15) # spread angle in degrees
			for i in range(-1, 2): # -1, 0, 1 = three lasers
				var laser = LaserScene.instantiate()
				laser.position = position
				var dir = facing_direction.rotated(spread * i)
				laser.direction = dir
				laser.rotation = dir.angle()
				get_parent().add_child(laser)
	
	#var laser = LaserScene.instantiate()
	#laser.position = position
	#laser.direction = facing_direction  # pass the direction
	#laser.rotation = laser.direction.angle()  # rotate the laser sprite
	#get_parent().add_child(laser)
