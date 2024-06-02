extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false
var no_movement: bool = false 


func _physics_process(delta):
	movement()
	jumping(delta)
	
func movement():
	# Prevent the player from contiuning to move while attacking 
	if not is_on_floor() && no_movement:
		velocity.y = 0.0 
		velocity.x = 0.0
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && !no_movement:
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
		
	# Move player based on input direction.
	var direction = Input.get_axis("left", "right")
	if direction && !no_movement:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		
	# Bring player to a stop when no input is detected. 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Play idle animation if player is not moving 
	if velocity.length() == 0.0 && !no_movement:
		animated_sprite.play("idle")
		
	# Flip the player's sprite if they are moving left. 
	if velocity.x < 0:
		animated_sprite.flip_h = true
	# Unflip the player's sprite if they are moving right. 
	elif velocity.x > 0:
		animated_sprite.flip_h = false
	
	# Apply movement 
	move_and_slide()
	
func jumping(delta):
	# Add the gravity.
	if not is_on_floor() && !no_movement:
		velocity.y += gravity * delta
		animated_sprite.play("fall")		
	
	# Play landing animation 
	if is_jumping and is_on_floor() && !no_movement:
		animated_sprite.play("land_on_ground")
		
func _on_combat_controller_attacking():
	no_movement = true

func _on_combat_controller_attack_ended():
	no_movement = false	

func _on_health_component_died():
	# Play death animation.
	no_movement = true 
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	# Remove player from scene. 
	queue_free()

func _on_health_component_took_damage():
	# Play hit animation. 
	animated_sprite.play("hit")
	await animated_sprite.animation_finished
