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

class Attack:
	var key
	var anim_name
	var can_attack
	var cooldown_timer
	var attacking
	var attack_ended
	var animated_sprite
	var cooldown_duration
	var hitbox
	var hitbox_collider
	var damage

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
		self.cooldown_timer.wait_time = self.cooldown_duration
		var callable = Callable(self, "reset_timer")
		self.cooldown_timer.connect("timeout", callable)
		
	func reset_timer():
		self.can_attack = true
	
	func attack(event: InputEvent):
		if event.is_action_pressed(self.key) && self.can_attack:
			self.hitbox.damage = self.damage
			self.hitbox_collider.disabled = false
			self.attacking.emit()
			self.animated_sprite.play(self.anim_name)
			await self.animated_sprite.animation_finished
			self.attack_ended.emit()
			self.can_attack = false
			self.cooldown_timer.start()
			self.hitbox_collider.disabled = true

func _ready():
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
	attack_1.attack(event)
	attack_2.attack(event)
	attack_3.attack(event)	
