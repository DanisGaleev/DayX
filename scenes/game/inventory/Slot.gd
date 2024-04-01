class_name Slot
extends TextureRect

@onready var count_label = $Count
@onready var description = $Description
@onready var icon = $Icon
@onready var destroying_label = $Destroying

var inventory: Array
var equip: Array
var one_time = true

var dragging = false
var drag_offset = Vector2.ZERO
var prev_pos: Vector2
var id: int

var item: ItemInfo
var player

#var click_count = 0
#var last_click_time = 0
	
func is_empty() -> bool:
	return self.item == null

func _ready():
	#connect("dropped", self, "set_position_by_id")
	set_process_input(true)
	inventory = get_parent().get_parent().get_parent().inventory
	equip = get_node("../../../").equip
	id = 0 if self.name.substr(4) == "" else int(self.name.substr(4)) - 1

func get_id_by_position(inventory_or_equip_zone=true) -> int:
	#var position = rect_position + rect_size / 2
	var position = global_position + size / 2
	if inventory_or_equip_zone: #inventory zone
		position -= Vector2(372, 50)
		return int(position.x) / 68 + int(position.y / 68) * 4
	else: #equip zone
		position -= Vector2(0, 50)
		return int(position.x) / 68 + int(position.y / 68) * 2

func in_inventory(pos: Vector2) -> bool:
	return pos.x <= 372 + 238 and pos.x >= 372 and pos.y <= 200 + 50 and pos.y >= 50
		
func in_equip(pos: Vector2) -> bool:
	return pos.x <= 132 and pos.x >= 0 and pos.y <= 268 + 50 and pos.y >= 0

func upd():
	if item != null and item.count > 0 and item.destroying < 1:
		icon.texture = item.icon_inventory
		item.weight = item.weight_per_one * item.count
		if item.destrouble:
			destroying_label.visible = true
			destroying_label.text = "{dest} / 100".format({"dest" : item.destroying * 100})
			count_label.visible = false
		else:
			destroying_label.visible = false
			count_label.visible = true
			count_label.text = str(item.count)
	else:
		item = null
		icon.texture = null
		count_label.text = ""
		destroying_label.text = ''
		description.text = ''

func _input(event):
	if event.is_action_pressed("print_inv_and_equip"):
		var e = ""
		print("INVENTORY")
		for i in range(inventory.size()):
			if inventory[i].item == null:
				e += " 0"
			else:
				e += " 1"
			if i > 0 and i % 4 == 3:
				print(e)
				e = ""
		print()
		print("EQUIP")
		e = ""
		for i in range(equip.size()):
			if equip[i].item == null:
				e += " 0"
			else:
				e += " 1"
			if i > 0 and i % 2 == 1:
				print(e)
				e = ""
		print()

func set_position_by_id(inventory_or_equip_zone=true):
	if inventory_or_equip_zone: #if in inventory zone
		set_global_position(Vector2(372 + self.id % 4 * 68, 50 + self.id / 4 * 68))
	else: #in in equip zone
		set_global_position(Vector2(0 + self.id % 2 * 68, 50 + self.id / 2 * 68))

func _process(delta):
	if item != null:
		$Info.visible = true
	else:
		$Info.visible = false
	if dragging:
		#set_global_position(get_viewport().get_mouse_position() - drag_offset)
		set_global_position(get_global_mouse_position() - drag_offset)
		one_time = false
	elif get_parent().get_parent().visible and not one_time:
		one_time = true
		var middle = get_global_rect().position + size / 2
		if in_inventory(middle): #check if now in inventory
			var swap_id = get_id_by_position()
			if in_equip(prev_pos): #check if was in equip
				if inventory[swap_id].item == null:
					inventory[swap_id].item = self.item
					inventory[swap_id].upd()
					
					self.item = null
					upd()
					set_position_by_id(false)
				else:
					upd()
					set_position_by_id(false)
			elif in_inventory(prev_pos): #check if was in inventory
				if inventory[swap_id].item != null:
					var swap_item = inventory[swap_id].item
					if swap_item.name == self.item.name and self.item.stackable: #check if can stack

						var diff = swap_item.max_count - swap_item.count
						if diff >= self.item.count: # check if can fetch
							swap_item.count += diff #swap normalisation
							inventory[swap_id].upd()
							inventory[swap_id].set_position_by_id()

							self.item = null #self normalisation
							upd()
							set_position_by_id()
						else: # if can't fetch
							swap_item.count = swap_item.max_count #swap normalisation
							inventory[swap_id].upd()
							inventory[swap_id].set_position_by_id()

							self.item.count -= diff #self normalisation
							upd()
							set_position_by_id()
					else: # if diffenent names or can't stack
						inventory[swap_id].item = self.item
						inventory[swap_id].upd()
						inventory[swap_id].set_position_by_id()
						self.item = swap_item

						upd()
						set_position_by_id()
				else: #if swap-item is null
					inventory[swap_id].item = self.item
					inventory[swap_id].upd()
					inventory[swap_id].set_position_by_id()

					self.item = null
					upd()
					set_position_by_id()
		elif in_equip(middle): #check if now in equip
			if in_inventory(prev_pos): #check if was in inventory
				var swap_id = get_id_by_position(false)
				if equip[swap_id].item != null:
					var swap_item = equip[swap_id].item
					if swap_item.type == self.item.type: #check if in right slot
							equip[swap_id].item = self.item
							equip[swap_id].upd()
							equip[swap_id].set_position_by_id(false)
							
							self.item = swap_item
							upd()
							set_position_by_id()
					else: #if slot type isn't right
						equip[swap_id].upd()
						equip[swap_id].set_position_by_id(false)

						upd()
						set_position_by_id()
				else: #if swap-item is null
					if self.item.type > Enums.ItemType.AMMO and self.item.type == equip[swap_id].id or (self.item.type == Enums.ItemType.WEAPON_FIRE and (equip[swap_id].id == 0 or equip[swap_id].id == 1)):
						equip[swap_id].item = self.item
						equip[swap_id].upd()
						equip[swap_id].set_position_by_id(false)
						self.item = null
						upd()
						set_position_by_id()
					#if self.item.type > Enums.ItemType.AMMO and (self.item.type - 1 == equip[swap_id].id) or (self.item.type == Enums.ItemType.WEAPON_FIRE and (equip[swap_id].id == 0 or equip[swap_id].id == 1)):
						#equip[swap_id].item = self.item
						#equip[swap_id].upd()
						#equip[swap_id].set_position_by_id(false)
						#print("eq")
						#self.item = null
						#upd()
						#set_position_by_id()
					else:
						upd()
						set_position_by_id()
			else: #if prev position was not in inventory
				set_position_by_id(false)
		else: #if swap in enmpy space -> remove from inv
			var new_item_on_ground = load("res://scenes/game/item_in_world/item.tscn").instantiate()
			get_node("../../../../../../World").add_child(new_item_on_ground)
			new_item_on_ground.position = player.position + Vector2(0, 10)
			new_item_on_ground.item_info = self.item
			new_item_on_ground.texture = item.icon_world
			player.weight -= item.count * item.weight_per_one
			item = null
			upd()
			if self in inventory:
				set_position_by_id()
			else:
				set_position_by_id(false)
		player.hand_weapon = equip[2].item
		player.weapon_fire_1 = equip[0].item
		player.weapon_fire_2 = equip[1].item
		player.armoring = 0
		player.cold_resistance = 0
		player.max_weight = 50
		for i in range(3, 8):# item in equip and 
			if equip[i].item!=null:
				player.armoring += equip[i].item.armoring
				player.cold_resistance += equip[i].item.cold_resistance
				prints(id, equip[i].item.max_carry_weight)
				player.max_weight += equip[i].item.max_carry_weight

func _on_Slot_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click") and item:
		if get_global_rect().has_point(get_global_mouse_position()):
			dragging = true
			prev_pos = global_position + size / 2
			drag_offset = get_global_mouse_position() - get_global_rect().position

	if event.is_action_released("left_click") and dragging and item:
		dragging = false
	#elif event.is_action("right_click") and item and not(item is WeaponFire or item is HandWeapon):
		#item.use([player, self])
	elif item and event.is_action("right_click") and item.type != Enums.ItemType.AMMO :#and (item is WeaponFire or item is HandWeapon):
		self.item.equip([player, self])
	elif item and event.is_action("right_click") and item.type == Enums.ItemType.AMMO :#and (item is WeaponFire or item is HandWeapon):
		item.use([player, self])

func _on_info_mouse_entered():
	if item != null:
		var desc = item.get_info()
		#var desc = "Name: %s\nDescription: %s\nStackable: %s\nCount: %s\n"
		#desc += "Max count: %s\nWeight per one: %s\nWeight: %s\nDestrouble: %s\nDestroying: %s\nDestroying value: %s\n"
		#desc = desc % [item.name, item.description, item.stackable, item.count, 
			#item.max_count, item.weight_per_one, item.weight_per_one * item.count, item.destrouble, item.destroying, item.destroying_value]
		#match item.type:
			#Enums.ItemType.AMMO:
				#desc += "Damage: %s\nSpeed: %s\nDamage diviation: %s\nDistance: %s\n"
				#desc = desc % [item.damage, item.speed, item.damage_diviation,
				 #item.distance]
				#desc += "Supported weapon:\n"
				#for nm in (item as Ammo).name_of_weapon:
					#desc += "	" + nm + "\n"
			#Enums.ItemType.DRESS:
				#desc += "Number of slots: %s\nCold resistance: %s\nArmoring: %s\nCarry weight: %s\n"
				#desc = desc % [item.slots_count, item.cold_resistance, item.armoring,
					#item.max_carry_weight]
		description.text = desc
		description.visible = true
	else:
		description.text = ''


func _on_info_mouse_exited():
	description.visible = false
	upd()
