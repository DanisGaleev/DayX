extends KinematicBody2D

class_name Character

enum Type {Zombie, Player}
enum State {
	Idle_forward,
	Run_forward,
	Idle_back,
	Run_back,
	Idle_left,
	Run_left,
	Idle_right,
	Run_right,
	Near_attack_right,
	Near_attack_forward,
	Near_attack_left,
	Near_attack_back
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
	State.Near_attack_forward : "near_attack_forward"
}

var movement = Vector2()
var last_direction = Vector2(0, 1)
var entered_body = []
var delta_time = 0
var block = false
var last_state
var regeneration_time = 0
var near_weapon setget set_near_weapon
var weapon_fire setget set_weapon_fire

export var speed = 10
export var attack = 10
export var type = Type.Zombie
export var state = State.Idle_back
export var health = 100
export var playerble = false
export var angry_distance = 50
export var wait_time = 0.1
export var regeneration_value = 1
export var regeneration_delta_time = 3

onready var animation = $Animation
onready var attack_zone = $AttackZone

func set_near_weapon(weapon) -> void:
	near_weapon = weapon

func set_weapon_fire(weapon) -> void:
	weapon_fire = weapon

func _ready():
	randomize()
	animation.play(animation_d[state])

func choose_direction():
	pass

func regenerate(delta):
	regeneration_time += delta
	if regeneration_time >= regeneration_delta_time and health <= 100:
		regeneration_time = 0
		health + min(regeneration_value, 100 - health)

func last_animation():
	state = last_state
	block = false
	
func rotate_attack_zone(angle):
	attack_zone.rotation = angle - PI / 2
	
func move():
	pass

func attack():
	pass
	
func upd(delta):
	pass
	
func is_died() -> bool:
	return health <= 0

func _process(delta):
	if is_died():
		queue_free()
	regenerate(delta)
	upd(delta)
	delta_time += delta
	if animation.animation != animation_d[state] and not block:
		animation.play(animation_d[state])


func _on_AttackZone_body_entered(body):
	if body != self:
		entered_body.append(body)


func _on_AttackZone_body_exited(body):
	if body != self:
		entered_body.remove(entered_body.find(body))
