extends Character

class_name Player

onready var fire_position = $AttackZone/FirePosition
var inventory: Inventory

var noise_level = 0.0
func _ready():
	._ready()
	inventory = get_parent().get_parent().get_node("GUI/CanvasLayer/Inv")
	inventory.player = self
	self.weapon_fire_2 = WeaponFire.new()
	self.weapon_fire_2.create(preload("res://assets/item_patterns/ak74_weapon_fire.tres"), 1, 0)

func _input(event):
	if event.is_action_pressed("weapon_near"):
		delta_time_near = near_weapon.wait_time
	elif event.is_action_pressed("fire_weapon_1"):
		type_of_weapon = WeaponType.FIRE_WEAPON_1
	elif event.is_action_pressed("fire_weapon_2"):
		type_of_weapon = WeaponType.FIRE_WEAPON_2

	if event.is_action_pressed("attack"):
		match(type_of_weapon):
			WeaponType.NEAR_WEAPON:
				if near_weapon == null:
					if delta_time_near >= wait_time:
						delta_time_near = 0.0
						attack()
						noise_level = 5.0
						yield(get_tree().create_timer(0.1), "timeout")
						noise_level = 0.0
				else:
					near_weapon.hit([self])
			WeaponType.FIRE_WEAPON_1:
				self.weapon_fire_1.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent()])
			WeaponType.FIRE_WEAPON_2:
				self.weapon_fire_2.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent()])
	if event.is_action_pressed("recharge"):
		recharge(inventory)
	if event.is_action_pressed("pick_up"):
		for item in get_tree().get_nodes_in_group("item_world"):
			if item.position.distance_to(position) <= 50:
				inventory.add_item(item.item_info, item)

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
		noise_level = 10.0
		
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
	match(type_of_weapon):
			WeaponType.NEAR_WEAPON:
				if near_weapon == null:
					delta_time_near += delta
				else:
					near_weapon.update(delta)
			WeaponType.FIRE_WEAPON_1:
				weapon_fire_1.update(delta)
			WeaponType.FIRE_WEAPON_2:
				weapon_fire_2.update(delta)
	rotate_attack_zone(self.position.direction_to(get_global_mouse_position()).angle())
				
func _physics_process(delta):
	choose_direction()
	move_and_slide(movement)
