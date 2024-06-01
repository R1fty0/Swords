extends Node2D

const PLAYER = preload("res://scenes/instantiables/player/player.tscn")

func _ready():
	# The index of the player stores in the players list on the GameManager. 
	var player_index = 0
	for i in GameManager.players:
		# Create a new player scene. 
		var current_player = PLAYER.instantiate()
		# Set the multiplayer authority of each player. 
		current_player.name = str(GameManager.players[i].id)
		# Add player to scene. 
		add_child(current_player)
		# Get spawn points. 
		for spawn_point in get_tree().get_nodes_in_group("SpawnPoints"):
			# Assign player their respective spawn point and update their position accordingly. 
			if spawn_point.name == str(player_index):
				current_player.global_position = spawn_point.global_position
		player_index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
