extends Node2D

# Emitted when the player is attacking 
signal attacking
# Emitted when the player's attack finished 
signal attack_ended

@export_category("Cooldowns")
@export var attack_1_cooldown: float = 0.25
@export var attack_2_cooldown: float = 0.35
@export var attack_3_cooldown: float = 0.45

@export_category("Damage")
@export var attack_1_damage: float = 10
@export var attack_2_damage: float = 20
@export var attack_3_damage: float = 30


var attack_1: Attack
var attack_2: Attack
var attack_3: Attack

@onready var animated_sprite = $"../AnimatedSprite2D"
@onready var attack_1_timer = $Timers/Attack1Timer
@onready var attack_2_timer = $Timers/Attack2Timer
@onready var attack_3_timer = $Timers/Attack3Timer
@onready var hitbox = $"../WeaponHitbox/Hitbox"
@onready var multiplayer_synchronizer = %MultiplayerSynchronizer





class Attack:
	var key: StringName
	var anim_name: StringName
	var can_attack: bool
	var cooldown_timer: Timer
	var cooldown_duration: float 
	var attacking: Signal
	var attack_ended: Signal
	var animated_sprite: AnimatedSprite2D
	var hitbox: Hitbox
	var hitbox_collider: CollisionShape2D
	var damage: float 
	
	func _init(key: StringName, anim_name: StringName, cooldown_timer: Timer, cooldown_duration: float, attacking: Signal, attack_ended: Signal, animated_sprite: AnimatedSprite2D, hitbox: Hitbox, damage: float):
		self.key = key
		self.anim_name = anim_name
		self.can_attack = true
		self.cooldown_timer = cooldown_timer
		self.attacking = attacking
		self.attack_ended = attack_ended
		self.animated_sprite = animated_sprite
		self.cooldown_duration = cooldown_duration
		self.hitbox = hitbox
		self.hitbox_collider = hitbox.get_node("CollisionShape2D")
		self.damage = damage 
		
	func setup_timer():
		cooldown_timer.wait_time = cooldown_duration
		var callable = Callable(self, "reset_timer")
		cooldown_timer.connect("timeout", callable)
		
	func reset_timer():
		can_attack = true
	
	func attack(event: InputEvent):
		if event.is_action_pressed(key) && can_attack:
			hitbox.damage = damage
			hitbox_collider.disabled = false
			attacking.emit()
			animated_sprite.play(anim_name)
			await animated_sprite.animation_finished
			attack_ended.emit()
			can_attack = false
			cooldown_timer.start()
			hitbox_collider.disabled = true


func _ready():
	if multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Initalize classes.
		attack_1 = Attack.new("fire1", "attack_1", attack_1_timer, attack_1_cooldown, attacking, attack_ended, animated_sprite, hitbox, attack_1_damage)
		attack_2 = Attack.new("fire2", "attack_2", attack_2_timer, attack_2_cooldown, attacking, attack_ended, animated_sprite, hitbox, attack_2_damage)
		attack_3 = Attack.new("fire3", "attack_3", attack_3_timer, attack_2_cooldown, attacking, attack_ended, animated_sprite, hitbox, attack_3_damage)
		
		# Set up attack cooldown timers and hitboxes. 
		attack_1.setup_timer()
		attack_2.setup_timer()
		attack_3.setup_timer()	
		
		# Disable hitbox on game start. 
		hitbox.get_node("CollisionShape2D").disabled = true
	
func _input(event):
	if multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		attack_1.attack(event)
		attack_2.attack(event)
		attack_3.attack(event)	
