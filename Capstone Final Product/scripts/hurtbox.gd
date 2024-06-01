extends Area2D
class_name Hurtbox

func _init():
	# Set up node to detect hitbox collisions. 
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Hitbox):
	# Do nothing if we collided with something that isn't a hitbox. 
	if hitbox == null:
		return 
		
	# Check if the object has a health component. 
	if owner.has_node("HealthComponent"):
		# Get the health component and deal damage to it. 
		owner.get_node("HealthComponent").take_damage(hitbox.damage)
