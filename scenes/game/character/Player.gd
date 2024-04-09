class_name Player
extends Character

var inventory: Inventory
var last_items_list = {}
var first_time_update = false
var noise_level = 0.0

@onready var fire_position = $AttackZone/FirePosition

func _ready():
	super()
	inventory = get_parent().get_parent().get_node("GUI/CanvasLayer/Inv")
	inventory.player = self

func _input(event):
	if event.is_action_pressed("hand_weapon"):
		type_of_weapon = WeaponType.NEAR_WEAPON
		#if hand_weapon:
			#delta_time_near = hand_weapon.wait_time
		if state <= State.IDLE_RIGHT or State.NEAR_ATTACK_FORWARD <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.IDLE_FORWARD
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.IDLE_LEFT
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.IDLE_RIGHT
			else:
				state = State.IDLE_BACK
	elif event.is_action_pressed("fire_weapon_1"):
		type_of_weapon = WeaponType.FIRE_WEAPON_1
		if state <= State.IDLE_RIGHT or State.NEAR_ATTACK_FORWARD <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.FIRE_ATTACK_FORWARD
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.FIRE_ATTACK_LEFT
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.FIRE_ATTACK_RIGHT
			else:
				state = State.FIRE_ATTACK_BACK
	elif event.is_action_pressed("fire_weapon_2"):
		type_of_weapon = WeaponType.FIRE_WEAPON_2
		if state <= State.IDLE_RIGHT or State.NEAR_ATTACK_FORWARD <= state:
			var angle = round(rad_to_deg(last_direction.angle()))
			if angle < -45 and angle > -135:
				state = State.FIRE_ATTACK_FORWARD
			elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
				state = State.FIRE_ATTACK_LEFT
			elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
				state = State.FIRE_ATTACK_RIGHT
			else:
				state = State.FIRE_ATTACK_BACK

	if event.is_action_pressed("attack") and not inventory.visible:
		match(type_of_weapon):
			WeaponType.NEAR_WEAPON:
				if hand_weapon == null:
					if delta_time_near >= wait_time:
						delta_time_near = 0.0
						attack_animation()
						enemy_hit(['player', 'zombie'], dmg)
						noise_level = 5.0
						await get_tree().create_timer(0.1).timeout
						noise_level = 0.0
				else:
					hand_weapon.hit([self, ["player", "zombie"]])
			WeaponType.FIRE_WEAPON_1:
				if weapon_fire_1 != null:
					self.weapon_fire_1.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent(), 1])
			WeaponType.FIRE_WEAPON_2:
				if weapon_fire_2 != null:
					self.weapon_fire_2.fire([self.position.direction_to(get_global_mouse_position()), fire_position.global_position, get_parent(), 2])
		
		for slot in inventory.equip:
			slot.upd()
	
	if event.is_action_pressed("recharge"):
		recharge(inventory)
		
	if event.is_action_pressed("sprint_run"):
		is_using_stamina = true
	if event.is_action_released("sprint_run"):
		is_using_stamina = false

func _physics_process(delta):
	choose_direction()
	set_velocity(movement)
	move_and_slide()

func upd(delta):
	match(type_of_weapon):
			WeaponType.NEAR_WEAPON:
				if  state < State.RUN_FORWARD  or State.NEAR_ATTACK_RIGHT < state:
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.IDLE_FORWARD
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.IDLE_LEFT
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.IDLE_RIGHT
					else:
						state = State.IDLE_BACK
				if hand_weapon == null:
					delta_time_near += delta
				else:
					hand_weapon.update(delta)
			WeaponType.FIRE_WEAPON_1:
				if  state < State.RUN_FORWARD  or State.RUN_RIGHT < state:
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.FIRE_ATTACK_FORWARD
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.FIRE_ATTACK_LEFT
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.FIRE_ATTACK_RIGHT
					else:
						state = State.FIRE_ATTACK_BACK
				if weapon_fire_1 != null:
					weapon_fire_1.update(delta)
			WeaponType.FIRE_WEAPON_2:
				if  state < State.RUN_FORWARD  or State.RUN_RIGHT < state:
					var angle = round(rad_to_deg(last_direction.angle()))
					if angle < -45 and angle > -135:
						state = State.FIRE_ATTACK_FORWARD
					elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
						state = State.FIRE_ATTACK_LEFT
					elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
						state = State.FIRE_ATTACK_RIGHT
					else:
						state = State.FIRE_ATTACK_BACK
				if weapon_fire_2 != null:
					weapon_fire_2.update(delta)

	rotate_attack_zone(self.position.direction_to(get_global_mouse_position()).angle())
	for animation_name in animations_dictionary:
			if animations_dictionary[animation_name].sprite_frames:
				animations_dictionary[animation_name].play(animation_and_states[state])

func choose_direction():
	var is_action = false
	movement = Vector2()
	if self.weight <= self.max_weight:
		if Input.is_action_pressed("up"):
			movement.y = -speed
			state = State.RUN_FORWARD
			is_action = true
		if Input.is_action_pressed("down"):
			movement.y = speed
			state = State.RUN_BACK
			is_action = true
		if Input.is_action_pressed("left"):
			movement.x = -speed
			state = State.RUN_LEFT
			is_action = true
		if Input.is_action_pressed("right"):
			movement.x = speed
			state = State.RUN_RIGHT
			is_action = true
	if is_action:
		if is_using_stamina:
			movement += movement.normalized() * strint_speed_boost
		last_direction = movement
		noise_level = 10.0
		
	if not is_action and state < State.NEAR_ATTACK_FORWARD:
		var angle = round(rad_to_deg(last_direction.angle()))
		if angle < -45 and angle > -135:
			state = State.IDLE_FORWARD
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.IDLE_LEFT
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.IDLE_RIGHT
		else:
			state = State.IDLE_BACK

func attack_animation():
	if state < State.RUN_FORWARD or state > State.RUN_RIGHT:
		last_state = state
		var angle = int(rad_to_deg(attack_zone.rotation) + 90)
		if angle < -45 and angle > -135:
			state = State.NEAR_ATTACK_FORWARD
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.NEAR_ATTACK_LEFT
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.NEAR_ATTACK_RIGHT
		else:
			state = State.NEAR_ATTACK_BACK
		block = true
		print_debug(animation_and_states[state])

func update_player_params():
	var equip = inventory.equip
	hand_weapon = equip[4].item
	weapon_fire_1 = equip[6].item
	weapon_fire_2 = equip[7].item
	armoring = 0
	cold_resistance = 0
	max_weight = 50
	
	for i in range(0, 8):# item in equip and has dress params
		if equip[i].item!=null and equip[i].item is Dress:
			armoring += equip[i].item.armoring
			cold_resistance += equip[i].item.cold_resistance
			max_weight += equip[i].item.max_carry_weight
	
	if equip[0].item != null:
		animations_dictionary["HelmetAnimation"].sprite_frames = equip[0].item.animation
	if equip[1].item != null:
		animations_dictionary["VestAnimation"].sprite_frames = equip[1].item.animation
	if equip[2].item != null:
		animations_dictionary["ShirtAnimation"].sprite_frames = equip[2].item.animation
	if equip[3].item != null:
		animations_dictionary["BagAnimation"].sprite_frames = equip[3].item.animation
	if equip[4].item != null:
		animations_dictionary["HandWeaponAnimation"].sprite_frames = equip[4].item.animation
	if equip[5].item != null:
		animations_dictionary["PantsAnimation"].sprite_frames = equip[5].item.animation
	if equip[6].item != null:
		animations_dictionary["Firearm1Animation"].sprite_frames = equip[6].item.animation
	if equip[7].item != null:
		animations_dictionary["Firearm2Animation"].sprite_frames = equip[7].item.animation
	
	

