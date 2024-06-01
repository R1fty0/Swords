extends Control

@export var health_component: HealthComponent
@onready var fill = $Fill

func _ready():
	# Set max health.
	# fill.max_value = health_component.max_health
	# Set health at game start. 
	# fill.value = health_component.max_health
	pass
	
func _process(_delta):
	#if health_component == null:
		#queue_free()
	#else:
		# Set health meter to match object's current health. 
		#fill.value = health_component.current_health
	pass
