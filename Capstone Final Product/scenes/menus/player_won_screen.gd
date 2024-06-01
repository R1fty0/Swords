extends CanvasLayer
class_name WinScreen 

var winning_player_name: StringName
@onready var animation_player = $AnimationPlayer
@onready var label = $PlayerNameLabel

func show_screen():
	animation_player.play("show")
	await animation_player.animation_finished
	hide_screen()
	
func hide_screen():
	animation_player.play("hide")
