class_name Slot
extends TextureRect

onready var count_label = $Count
onready var description = $Description
onready var icon = $Icon

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
	var position = rect_global_position + rect_size / 2
	if inventory_or_equip_zone: #inventory zone
		position -= Vector2(196, 57)
		return int(position.x) / 68 + int(position.y / 68) * 4
	else: #equip zone
		return int(position.x) / 68 + int(position.y / 68) * 2

func upd():
	if item != null and item.count > 0:
		icon.texture = item.icon_inventory
		count_label.text = str(item.count)
	else:
		item = null
		icon.texture = null
		count_label.text = ""

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
		set_global_position(Vector2(196 + self.id % 4 * 68, 57 + self.id / 4 * 68))
	else: #in in equip zone
		set_global_position(Vector2(0 + self.id % 2 * 68, 0 + self.id / 2 * 68))

func _process(delta):
	if dragging:
		set_global_position(get_viewport().get_mouse_position() - drag_offset)
		one_time = false
	elif get_parent().get_parent().visible and not one_time:
		one_time = true
		var middle = rect_global_position + rect_size / 2
		if middle.x <= 464 and middle.x >= 196 and middle.y <= 257 and middle.y >= 57: #check if now in inventory
			var swap_id = get_id_by_position()
			if prev_pos.x <= 132 and prev_pos.x >= 0 and prev_pos.y <= 268 and prev_pos.y >= 0: #check if was in equip
				if inventory[swap_id].item == null:
					print("spawp id", swap_id)
					inventory[swap_id].item = self.item
					inventory[swap_id].upd()
					

					self.item = null
					upd()
					set_position_by_id(false)
				else:
					upd()
					set_position_by_id(false)
			elif prev_pos.x <= 464 and prev_pos.x >= 196 and prev_pos.y <= 257 and prev_pos.y >= 57: #check if was in inventory
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
		elif middle.x <= 132 and middle.x >= 0 and middle.y <= 268 and middle.y >= 0: #check if now in equip
			if prev_pos.x <= 464 and prev_pos.x >= 196 and prev_pos.y <= 257 and prev_pos.y >= 57: #check if was in inventory
				print(rect_position)
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
					print("was in inventory", swap_id)
					if self.item.type > Enums.ItemType.AMMO and (self.item.type - 1 == equip[swap_id].id) or (self.item.type == Enums.ItemType.WEAPON_FIRE and (equip[swap_id].id == 0 or equip[swap_id].id == 1)):
						equip[swap_id].item = self.item
						equip[swap_id].upd()
						equip[swap_id].set_position_by_id(false)

						self.item = null
						upd()
						set_position_by_id()
					else:
						upd()
						set_position_by_id()
			else: #if prev position was not in inventory
				set_position_by_id(false)
		else: #if swap in enmpy space -> remove from inv
			var new_item_on_ground = load("res://scenes/game/items_in_world/item.tscn").instance()
			new_item_on_ground.position = player.position + Vector2(0, 10)
			new_item_on_ground.item_info = self.item
			get_node("../../../../../../World").add_child(new_item_on_ground)
			item = null
			upd()
			if self in inventory:
				set_position_by_id()
			else:
				set_position_by_id(false)
		player.near_weapon = equip[2].item
		player.weapon_fire_1 = equip[0]
		player.weapon_fire_2 = equip[1]


func _on_Slot_mouse_entered():
	description.visible = true

func _on_Slot_mouse_exited():
	description.visible = false


func _on_Slot_gui_input(event: InputEvent):
#	if item != null and event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			click_count += 1
#			if click_count == 2 and OS.get_ticks_msec() - last_click_time < 250:
#				if item.type > 1:
#					var change_slot_item = equip[item.type - 1].item
#					print(change_slot_item)
#					equip[item.type - 1].item = self.item
#					equip[item.type - 1].upd()
#					print(change_slot_item)
#					self.item = change_slot_item
#					upd()
#				click_count = 0
#			last_click_time = OS.get_ticks_msec()
	if event.is_action_pressed("left_click") and item:
		if get_global_rect().has_point(event.global_position):
			dragging = true
			prev_pos = rect_global_position + rect_size / 2
			drag_offset = event.global_position - get_global_rect().position

	if event.is_action_released("left_click") and dragging and item:
		dragging = false
	elif event.is_action("right_click") and item and not(item is WeaponFire or item is HandWeapon):
		item.use([player])
	elif event.is_action("right_click") and item and (item is WeaponFire or item is HandWeapon):
		item.equip([player])
