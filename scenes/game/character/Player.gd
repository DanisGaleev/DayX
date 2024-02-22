extends Character

class_name Player

@onready var fire_position = $AttackZone/FirePosition
var inventory: Inventory

var noise_level = 0.0
func _ready():
	super._ready()
	inventory = get_parent().get_parent().get_node("GUI/CanvasLayer/Inv")
	inventory.player = self

func _input(event):
	if event.is_action_pressed("hand_weapon"):
		type_of_weapon = WeaponType.NEAR_WEAPON
		if hand_weapon:
			delta_time_near = hand_weapon.wait_time
		if state <= State.Idle_right or State.Near_attack_forward <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.Idle_forward
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.Idle_left
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.Idle_right
			else:
				state = State.Idle_back
	elif event.is_action_pressed("fire_weapon_1"):
		type_of_weapon = WeaponType.FIRE_WEAPON_1
		if state <= State.Idle_right or State.Near_attack_forward <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.Fire_attack_forward
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.Fire_attack_left
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.Fire_attack_right
			else:
				state = State.Fire_attack_back
	elif event.is_action_pressed("fire_weapon_2"):
		type_of_weapon = WeaponType.FIRE_WEAPON_2
		if state <= State.Idle_right or State.Near_attack_forward <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.Fire_attack_forward
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.Fire_attack_left
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.Fire_attack_right
			else:
				state = State.Fire_attack_back
	if event.is_action_pressed("attack"):
		match(type_of_weapon):
			WeaponType.NEAR_WEAPON:
				if hand_weapon == null:
					if delta_time_near >= wait_time:
						delta_time_near = 0.0
						attack()
						noise_level = 5.0
						await get_tree().create_timer(0.1).timeout
						noise_level = 0.0
				else:
					hand_weapon.hit([self])
			WeaponType.FIRE_WEAPON_1:
				if weapon_fire_1 != null:
					self.weapon_fire_1.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent(), 1])
			WeaponType.FIRE_WEAPON_2:
				if weapon_fire_2 != null:
					self.weapon_fire_2.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent(), 2])
		for slt in inventory.equip:
			slt.upd()
	if event.is_action_pressed("recharge"):
		recharge(inventory)
	if event.is_action_pressed("pick_up"):
		for item in get_tree().get_nodes_in_group("item_world"):
			if item.global_position.distance_to(position) <= 50:
				inventory.add_item(item.item_info, item)

func attack():
	if state < State.Run_forward or state > State.Run_right:
		last_state = state
		var min_dst = 9999
		var angle = int(rad_to_deg(attack_zone.rotation) + 90)
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

	#await animation.animation_finished
	#last_animation()
	for body in entered_body:
		if body is Character:
			body.health -= dmg

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
	if self.weight > self.max_weight:
		movement = Vector2.ZERO
	if is_action:
		last_direction = movement
		noise_level = 10.0
		
	if not is_action and state < State.Near_attack_forward:
		var angle = round(rad_to_deg(last_direction.angle()))
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
				if  state < State.Run_forward  or State.Near_attack_right < state :
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.Idle_forward
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.Idle_left
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.Idle_right
					else:
						state = State.Idle_back
				if hand_weapon == null:
					delta_time_near += delta
				else:
					hand_weapon.update(delta)
			WeaponType.FIRE_WEAPON_1:
				if  state < State.Run_forward  or State.Run_right < state :
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.Fire_attack_forward
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.Fire_attack_left
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.Fire_attack_right
					else:
						state = State.Fire_attack_back
				if weapon_fire_1 != null:
					weapon_fire_1.update(delta)
			WeaponType.FIRE_WEAPON_2:
				if  state < State.Run_forward  or State.Run_right < state :
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.Fire_attack_forward
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.Fire_attack_left
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.Fire_attack_right
					else:
						state = State.Fire_attack_back
				if weapon_fire_2 != null:
					weapon_fire_2.update(delta)
	rotate_attack_zone(self.position.direction_to(get_global_mouse_position()).angle())
	for anm in animations_dictionary:
			if animations_dictionary[anm].sprite_frames:
				animations_dictionary[anm].play(animation_d[state])
func _physics_process(delta):
	choose_direction()
	set_velocity(movement)
	move_and_slide()
