class_name Slot
extends TextureRect

@onready var count_label = $Count
@onready var description = $Description
@onready var icon = $Icon
@onready var destroying_label = $Destroying

@export var icon_size: Vector2 = Vector2(64, 64)

var inventory: Array
var equip: Array
var one_time = true

var dragging = false
var drag_offset = Vector2.ZERO
var prev_pos: Vector2
var id: int

var item: ItemInfo
var player
	
func is_empty() -> bool:
	return self.item == null

func _ready():
	icon.custom_minimum_size = icon_size
	icon.size = icon_size
	icon.stretch_mode = EXPAND_KEEP_SIZE
	icon.stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
	set_process_input(true)
	inventory = get_parent().get_parent().get_parent().inventory
	equip = get_node("../../../").equip
	match name:
			"Helmet":
				id = 0
			"Vest":
				id = 1
			"Shirt":
				id = 2
			"Bag":
				id = 3
			"HandWeapon":
				id = 4
			"Pants":
				id = 5
			"Firearm1":
				id = 6
			"Firearm2":
				id = 7
			_:
				id = 0 if self.name.substr(4) == "" else int(self.name.substr(4)) - 1
func get_id_by_position(inventory_or_equip_zone=true) -> int:
	var mid_pos = global_position + size / 2
	if inventory_or_equip_zone: #inventory zone
		position -= Vector2(372, 50)
		return int(mid_pos.x) / 68 + int(mid_pos.y / 68) * 4
	else: #equip zone
		mid_pos -= Vector2(0, 50)
		return int(mid_pos.x) / 68 + int(mid_pos.y / 68) * 2

func in_inventory(pos: Vector2) -> bool:
	return pos.x <= 372 + 238 and pos.x >= 372 and pos.y <= 200 + 50 and pos.y >= 50
		
func in_equip(pos: Vector2) -> bool:
	prints(pos, "postion")
	if pos.x >= 65 and pos.x <= 65 + 57 and pos.y >= 57 and pos.y <= 57 + 57:
		return true
	if pos.x >= 8 and pos.x <= 8 + 57 and pos.y > 97 and pos.y <= 97 + 57:
		return true
	if pos.x >= 65 and pos.x <= 65 + 57 and pos.y >= 97 and pos.y <= 97 + 57:
		return true
	if pos.x >= 122 and pos.x <= 122 + 57 and pos.y >= 97 and pos.y <= 97 + 57:
		return true
	if pos.x >= 8 and pos.x <= 8 + 57 and pos.y > 154 and pos.y <= 154 + 57:
		return true
	if pos.x >= 65 and pos.x <= 65 + 57 and pos.y >= 154 and pos.y <= 154 + 57:
		return true
	if pos.x >= 8 and pos.x <= 8 + 180 and pos.y > 211 and pos.y <= 211 + 57:
		return true
	if pos.x >= 8 and pos.x <= 8 + 180 and pos.y > 268 and pos.y <= 268 + 57:
		return true
	return false

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
		prints("id", id)
		match id:
			0:
				set_global_position(Vector2(65, 40))
			1:
				set_global_position(Vector2(8, 97))
			2:
				set_global_position(Vector2(65, 97))
			3:
				set_global_position(Vector2(122, 97))
			4:
				set_global_position(Vector2(8, 154))
			5:
				set_global_position(Vector2(65, 154))
			6:
				set_global_position(Vector2(8, 211))
			7:
				set_global_position(Vector2(8, 268))

func _process(delta):
	if item != null:
		$Info.visible = true
	else:
		$Info.visible = false
	if dragging:
		set_global_position(get_global_mouse_position() - drag_offset)
		one_time = false
	elif get_parent().get_parent().visible and not one_time:
		one_time = true
		var middle = get_global_rect().position + size / 2
		print(middle)
		if in_inventory(middle): #check if now in inventory
			var swap_id = get_id_by_position()
			print(prev_pos)
			if in_equip(prev_pos): #check if was in equip
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
				upd()
				set_position_by_id()
			else: #if prev position was not in inventory
				upd()
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
		for i in range(0, 8):# item in equip and has dress params
			if equip[i].item!=null and equip[i].item is Dress:
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
	elif item and event.is_action("right_click") and item.type != Enums.ItemType.AMMO :#and (item is WeaponFire or item is HandWeapon):
		self.item.equip([player, self])
	elif item and event.is_action("right_click") and item.type == Enums.ItemType.AMMO :#and (item is WeaponFire or item is HandWeapon):
		print("RRRR")
		item._use([player, self])

func _on_info_mouse_entered():
	if item != null:
		var desc = item._get_info()
		description.text = desc
		description.visible = true
	else:
		description.text = ''


func _on_info_mouse_exited():
	description.visible = false
	upd()
