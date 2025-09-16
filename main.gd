extends Node

@export var mob_scene: PackedScene
@export var satellite_scene: PackedScene 
  
var score: int =0
var temp: int =0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!($Player.weapon_type == $Player.WeaponType.SHOTGUN)):
		if(score > temp + 40 ):
			spawn_satellite()
			temp=score
	

func _on_player_hit() :
	game_over()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()



func new_game():
	score = 0
	temp=0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	mob.connect("killed", Callable(self, "_on_mob_killed"))
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_killed():
	score += 10
	$HUD.update_score(score)
	
func spawn_satellite():
	
	var satellite = satellite_scene.instantiate()
	var y_pos = randf_range(30, 750)
	var x_pos = randf_range(30, 450)
	satellite.position = Vector2(x_pos, y_pos)
	satellite.connect("killed", Callable(self, "_on_satellite_killed"))
	add_child(satellite)
	#print("Satellite spawned at: ", satellite.position)

	
func _on_satellite_killed():
	$Player.weapon_type = $Player.WeaponType.SHOTGUN
	$HUD.show_message("SHOTGUN UNLOCKED!")
	$PowerUpTimer.start()
	
func _on_power_up_timer_timeout():
	$Player.weapon_type = $Player.WeaponType.NORMAL
	$HUD.show_message("Back to normal")
