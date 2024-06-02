extends Node2D

const PLAYER = preload("res://scenes/instantiables/player/player.tscn")
const PORT = 9293
@onready var main_menu = $MainMenu
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	main_menu.show()


func _on_host_button_down():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	spawn_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(spawn_player)

func _on_join_button_down():
	main_menu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func spawn_player(peer_id):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
