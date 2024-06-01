extends Node2D
class_name HealthComponent 

signal died
signal took_damage 

@export var max_health: float = 100
var current_health: float = 100

func _ready():
	# Set health at beginning of the game. 
	current_health = max_health

func take_damage(damage: float):
	# Subtract damage from current health.
	current_health -= damage
	took_damage.emit()
	# Emit a death signal once the health falls below 0. 
	if current_health <= 0:
		died.emit()
