extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# To get mob types via animation types
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# for this type of game it is neccessary to do this.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
