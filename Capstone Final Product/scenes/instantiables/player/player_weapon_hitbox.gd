extends Hitbox

@export var left_hitbox_pos: Marker2D
@export var right_hitbox_pos: Marker2D
@export var player: Player

# Move the hitbox to match the player's current direction of travel. 
func _process(delta):
	# Player moving left. 
	if player.velocity.x < 0:
		position = left_hitbox_pos.position
	# Player moving right. 
	elif player.velocity.x > 0:
		position = right_hitbox_pos.position

