extends Node

# Scene used to create new mobs during gameplay.
@export var mob_scene: PackedScene

# Tracks the player's score.
var score


# Called once when this node enters the scene tree.
func _ready():
	new_game()


# Called every frame.
func _process(delta: float) -> void:
	pass


# Called when the player emits the "hit" signal.
# Stops the game by stopping the timers that create mobs and score points.
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()


# Resets the game state and starts a new round.
func new_game():
	score = 0

	# Reset the player to the starting position and enable control.
	$Player.start($StartPosition.position)

	# Start the delay before mobs begin spawning.
	$ScoreTimer.start()


# Called whenever the MobTimer times out.
# Creates and launches a new mob from a random point on the spawn path.
func _on_mob_timer_timeout():
	# Create a new mob instance from the Mob scene.
	var mob = mob_scene.instantiate()

	# PathFollow2D used to pick a random spawn position on the Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation

	# Move to a random point along the path.
	mob_spawn_location.progress_ratio = randf()

	# Place the mob at the selected position.
	mob.position = mob_spawn_location.position

	# Get the direction perpendicular to the path.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness so mobs spread out.
	direction += randf_range(-PI / 4, PI / 4)

	# Rotate the mob to face its movement direction.
	mob.rotation = direction

	# Create a random speed and convert it into a velocity vector.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Add the mob to the scene so it becomes active.
	add_child(mob)


# Called every second (or whatever interval ScoreTimer uses).
# Increases the player's score over time.
func _on_score_timer_timeout() -> void:
	score += 1


# Called when the StartTimer finishes.
# Begins spawning mobs and counting score.
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()