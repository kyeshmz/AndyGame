extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ is shorthand for get_node(), and in this case its get_node("AnimatedSprite2D")
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	# delta refers to how long the last frame took
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	#if velocity.x != 0:
		# this is how we choose between different animation frames, but for now we are just using ours
	#	$AnimatedSprite2D.animation = "walk"
	#	$AnimatedSprite2D.flip_v = false
	#	# See the note below about boolean assignment.
	#	$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y != 0:
	#	$AnimatedSprite2D.animation = "up"
	#	$AnimatedSprite2D.flip_v = velocity.y > 0
	


func _on_body_entered(body):
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	# or in more easier terms, Disabling the area's collision shape can cause an error if it happens in the middle of the engine's collision processing.
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

