extends Area2D
class_name Hitbox

@export var damage: float = 10

func _init():
	# Set up node to collide with hurtboxes.
	collision_layer = 2
	collision_mask = 0
	
