extends CharacterBody2D

class_name Character

enum Type {Zombie, Player}
enum WeaponType{
	NEAR_WEAPON,
	FIRE_WEAPON_1,
	FIRE_WEAPON_2
}
#enum State {
	#Idle_forward,
	#Run_forward,
	#Idle_back,
	#Run_back,
	#Idle_left,
	#Run_left,
	#Idle_right,
	#Run_right,
	#Near_attack_right,
	#Near_attack_forward,
	#Near_attack_left,
	#Near_attack_back
#}

enum State {
	Idle_forward,
	Idle_back,
	Idle_left,
	Idle_right,
	Run_forward,
	Run_back,
	Run_left,
	Run_right,
	Near_attack_forward,
	Near_attack_back,
	Near_attack_left,
	Near_attack_right,
	Fire_attack_forward,
	Fire_attack_back,
	Fire_attack_left,
	Fire_attack_right,
}
var animation_d = {
	State.Idle_forward : "idle_forward",
	State.Run_forward : "run_forward",
	State.Idle_back : "idle_back",
	State.Run_back : "run_back",
	State.Idle_left : "idle_left",
	State.Run_left : "run_left",
	State.Idle_right : "idle_right",
	State.Run_right : "run_right",
	State.Near_attack_back : "near_attack_back",
	State.Near_attack_left : "near_attack_left",
	State.Near_attack_right : "near_attack_right",
	State.Near_attack_forward : "near_attack_forward",
	State.Fire_attack_back : "fire_attack_back",
	State.Fire_attack_left : "fire_attack_left",
	State.Fire_attack_right : "fire_attack_right",
	State.Fire_attack_forward : "fire_attack_forward",
}

var movement = Vector2()
var last_direction = Vector2(0, 1)
var entered_body = []
var delta_time_near = 0
var block = false
var last_state
var regeneration_time = 0
var hand_weapon
var weapon_fire_1
var weapon_fire_2
var type_of_weapon = WeaponType.NEAR_WEAPON

@export var speed = 10
@export var dmg = 10
@export var type = Type.Zombie
@export var state = State.Idle_back
@export var health = 100
@export var hunger = 20
@export var thirst = 20
@export var armor = 0
@export var cold_resistance = 0
@export var playerble = false
@export var angry_distance = 50
@export var wait_time = 0.1
@export var regeneration_value = 1
@export var regeneration_delta_time = 3

@onready var animation = $Animation
@onready var attack_zone = $AttackZone

@onready var animations = $Animations

var animations_dictionary:Dictionary

signal attack_animation_finished
func _ready():
	for anm in animations.get_children():
		animations_dictionary[anm.name] = anm
	randomize()
	animation.play(animation_d[state])
	animation.animation_finished.connect(last_animation)

func choose_direction():
	pass

func regenerate(delta):
	regeneration_time += delta
	if regeneration_time >= regeneration_delta_time and health <= 100:
		regeneration_time = 0
		health + min(regeneration_value, 100 - health)

func last_animation():
	if block:
		state = last_state
		block = false
	
func rotate_attack_zone(angle):
	attack_zone.rotation = angle - PI / 2
	
func move():
	pass

func attack():
	pass
func recharge(inventory):
	match(type_of_weapon):
			WeaponType.FIRE_WEAPON_1:
				if weapon_fire_1:
					weapon_fire_1.recharge(inventory)
			WeaponType.FIRE_WEAPON_2:
				if weapon_fire_2:
					weapon_fire_2.recharge(inventory)

func upd(delta):
	pass
	
func is_died() -> bool:
	return health <= 0

func _process(delta):
	if is_died():
		queue_free()
	regenerate(delta)
	upd(delta)
	delta_time_near += delta
	if animation.animation != animation_d[state] and not block:
		animation.play(animation_d[state])


func _on_AttackZone_body_entered(body):
	if body != self:
		entered_body.append(body)


func _on_AttackZone_body_exited(body):
	if body != self:
		entered_body.remove_at(entered_body.find(body))
