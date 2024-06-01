extends AnimatedSprite2D


func _ready():
	# Play idle animation on game start. 
	play("idle")

func _on_health_component_took_damage():
	# Play hit animation. 
	play("hit")
	await animation_finished
	# Resume playing idle animation. 
	play("idle")

func _on_health_component_died():
	# Play destroyed animation.
	play("destroyed")
	await animation_finished
	# Destroy barrel.
	queue_free()

