
const MAP_1 = preload("res://scenes/levels/maps/map_1.tscn")
const PORT = 3245
const ADDRESS = "localhost"
@export_range(1, 4) var number_of_clients = 4

var enet_peer: ENetMultiplayerPeer


func _on_host_button_down():
	# Hide main menu
	pass

func _on_join_button_down():
	pass # Replace with function body.
