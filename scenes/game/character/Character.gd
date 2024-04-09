extends CharacterBody2D

class_name Character

signal item_detected(item_near)
signal attack_animation_finished

enum Type {ZOMBIE, PLAYER}
enum WeaponType{NEAR_WEAPON, FIRE_WEAPON_1, FIRE_WEAPON_2}

enum State {
	IDLE_FORWARD,
	IDLE_BACK,
	IDLE_LEFT,
	IDLE_RIGHT,
	RUN_FORWARD,
	RUN_BACK,
	RUN_LEFT,
	RUN_RIGHT,
	NEAR_ATTACK_FORWARD,
	NEAR_ATTACK_BACK,
	NEAR_ATTACK_LEFT,
	NEAR_ATTACK_RIGHT,
	FIRE_ATTACK_FORWARD,
	FIRE_ATTACK_BACK,
	FIRE_ATTACK_LEFT,
	FIRE_ATTACK_RIGHT,
}
var animation_and_states = {
	State.IDLE_FORWARD : "idle_forward",
	State.RUN_FORWARD : "run_forward",
	State.IDLE_BACK : "idle_back",
	State.RUN_BACK : "run_back",
	State.IDLE_LEFT : "idle_left",
	State.RUN_LEFT : "run_left",
	State.IDLE_RIGHT : "idle_right",
	State.RUN_RIGHT : "run_right",
	State.NEAR_ATTACK_BACK : "near_attack_back",
	State.NEAR_ATTACK_LEFT : "near_attack_left",
	State.NEAR_ATTACK_RIGHT : "near_attack_right",
	State.NEAR_ATTACK_FORWARD : "near_attack_forward",
	State.FIRE_ATTACK_BACK : "fire_attack_back",
	State.FIRE_ATTACK_LEFT : "fire_attack_left",
	State.FIRE_ATTACK_RIGHT : "fire_attack_right",
	State.FIRE_ATTACK_FORWARD : "fire_attack_forward",
}

@export_category("Base params")
@export var health = 100
@export var hunger = 20
@export var hunger_increase_speed = 1
@export var thirst = 20
@export var thirst_increase_speed = 1
@export var speed = 10
@export var dmg = 10
@export var armoring = 0
@export var cold_resistance = 0
@export var type = Type.ZOMBIE
@export var max_weight = 100

@export_category("Stamina params")
@export var max_stamina = 100
@export var stamina_cost_per_second = 20
@export var stamina_regen_per_second = 5
@export var strint_speed_boost = 5

@export_category("Other")
@export var state = State.IDLE_BACK
@export var playerble = false
@export var angry_distance = 50
@export var wait_time = 0.1
@export var regeneration_value = 1
@export var regeneration_delta_time = 3

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
var weight: float = 0.0
var current_stamina = 0.0
var is_using_stamina = false
var item_near = []
var animations_dictionary:Dictionary

@onready var animation = $Animation
@onready var attack_zone = $AttackZone

@onready var animations = $Animations


func _ready():
	current_stamina = max_stamina
	for anm in animations.get_children():
		animations_dictionary[anm.name] = anm
	animation.play(animation_and_states[state])
	animation.animation_finished.connect(last_animation)

func _process(delta):
	if is_died():
		queue_free()
	regenerate(delta)
	upd(delta)
	update_stamina(delta)
	delta_time_near += delta
	if animation.animation != animation_and_states[state] and not block:
		animation.play(animation_and_states[state])

func upd(delta) -> void:
	pass

func choose_direction() -> void:
	pass
	
func move() -> void:
	pass
	
func update_stamina(delta):
	if is_using_stamina:
		current_stamina = max(0, current_stamina - stamina_cost_per_second * delta)
		if current_stamina <= 0:
			is_using_stamina = false
			current_stamina = 0
	else:
		current_stamina = min(current_stamina + stamina_regen_per_second * delta, max_stamina)
	
func rotate_attack_zone(angle) -> void:
	attack_zone.rotation = angle - PI / 2
	
func attack_animation() -> void:
	pass
	
func enemy_hit(enemy_groups: Array, damage: float) -> void:
	for body in entered_body:
		if intersect(body.get_groups(), enemy_groups):
			body.health -= damage

func is_died() -> bool:
	return health <= 0
	
func recharge(inventory) -> void:
	match(type_of_weapon):
			WeaponType.FIRE_WEAPON_1:
				if weapon_fire_1:
					weapon_fire_1.recharge(inventory)
			WeaponType.FIRE_WEAPON_2:
				if weapon_fire_2:
					weapon_fire_2.recharge(inventory)

func regenerate(delta) -> void:
	regeneration_time += delta
	if thirst != 100 and hunger != 100 and \
		regeneration_time >= regeneration_delta_time and health <= 100:
		regeneration_time = 0
		health += min(regeneration_value, 100 - health)

func hunger_update(delta) -> void:
	hunger += min(delta * hunger_increase_speed, 100 - hunger)

func thirst_updare(delta):
	thirst += min(delta * thirst_increase_speed, 100 - thirst)

func last_animation() -> void:
	if block:
		state = last_state
		block = false
	
func intersect(array1, array2):
	var intersection = false
	for item in array1:
		if array2.has(item):
			intersection = true
			break
	return intersection

func _on_AttackZone_body_entered(body):
	if body != self:
		entered_body.append(body)
		
func _on_AttackZone_body_exited(body):
	if body != self:
		entered_body.remove_at(entered_body.find(body))

func _on_items_trigger_area_entered(area):
	if area.is_in_group("items"):
		item_near.append(area.get_parent())
		item_detected.emit(item_near)

func _on_items_trigger_area_exited(area):
	if area.is_in_group("items"):
		item_near.erase(area.get_parent())
		item_detected.emit(item_near)
