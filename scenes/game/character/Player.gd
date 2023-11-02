extends Character

class_name Player

onready var fire_position = $AttackZone/FirePosition
var inventory: Inventory

var akm: WeaponFire
func _ready():
	._ready()
	inventory = get_parent().get_parent().get_node("GUI/CanvasLayer/Inventory")
	var ammo = Ammo.new()
	ammo.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 60, 0)
	akm = WeaponFire.new()
	akm.create(preload("res://assets/item_patterns/m4_weapon_fire.tres"), 1, 0)
	ammo.use([akm])

func _input(event):
	if event.is_action_pressed("attack") and delta_time >= wait_time:
		delta_time = 0
		attack()
	if event.is_action_pressed("fire_attack"):
		akm.use([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent()])
	if event.is_action_pressed("recharge"):
		akm.recharge()
	if event.is_action_pressed("pick_up"):
		for item in get_tree().get_nodes_in_group("item_world"):
			if item.position.distance_to(position) <= 50:
				inventory.add_item(item.item_info, item)
				#item.queue_free()
func attack():
	last_state  = state
	var min_dst = 9999
	var angle = int(rad2deg(attack_zone.rotation) + 90)
	if angle < -45 and angle > -135:
		state = State.Near_attack_forward
	elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
		state = State.Near_attack_left
	elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
		state = State.Near_attack_right
	else:
		state = State.Near_attack_back
	block = true
	animation.play(animation_d[state])

	yield(animation, "animation_finished")
	last_animation()
	
	for body in entered_body:
		if body is Character:
			body.health -= attack

func choose_direction():
	var is_action = false
	movement = Vector2()

	if Input.is_action_pressed("up"):
		movement.y = -speed
		state = State.Run_forward
		is_action = true
	if Input.is_action_pressed("down"):
		movement.y = speed
		state = State.Run_back
		is_action = true
	if Input.is_action_pressed("left"):
		movement.x = -speed
		state = State.Run_left
		is_action = true
	if Input.is_action_pressed("right"):
		movement.x = speed
		state = State.Run_right
		is_action = true
	if is_action:
		last_direction = movement
		
	if not is_action:
		var angle = round(rad2deg(last_direction.angle()))
		if angle < -45 and angle > -135:
			state = State.Idle_forward
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.Idle_left
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.Idle_right
		else:
			state = State.Idle_back
func upd(delta):
	akm.update(delta)
	#akm.delta_time_between = akm.upd(delta, akm.delta_time_between)
	rotate_attack_zone(self.position.direction_to(get_global_mouse_position()).angle())
				
func _physics_process(delta):
	choose_direction()
	move_and_slide(movement)
