extends Control
class_name Inventory
var inventory = []
var equip = []

@onready var grid_inventory = $Inventory/InventoryGrid
@onready var grid_equip = $EquipInv/Control
@onready var item_on_ground = $ItemsList/VBoxContainer
var player

func _ready():
	for i in grid_inventory.get_children():
		i.player = player
		inventory.append(i)
	for j in grid_equip.get_children():
		j.player = player
		equip.append(j)
		prints(j.name, equip.size() - 1)
	player.item_detected.connect(_on_update_items_menu)
func _input(event):
	if event.is_action_pressed("inventory"):
		visible = not visible
		
func add_item(item: ItemInfo, item_container: Sprite2D):
	match item.type:
		Enums.ItemType.DRESS:
			match item.dress_type:
				Enums.DressType.ARMOR:
					if equip[1].item == null:
						equip[1].item = item_info_copy(item.type, item)
						item.count = 0
						equip[1].upd()
				Enums.DressType.BACKPACK:
					if equip[3].item == null:
						equip[3].item = item_info_copy(item.type, item)
						item.count = 0
						equip[3].upd()
				Enums.DressType.HEADDRESS:
					if equip[0].item == null:
						equip[0].item = item_info_copy(item.type, item)
						item.count = 0
						equip[0].upd()
				Enums.DressType.PANTS:
					if equip[5].item == null:
						equip[5].item = item_info_copy(item.type, item)
						item.count = 0
						equip[5].upd()
				Enums.DressType.SHIRT:
					if equip[2].item == null:
						equip[2].item = item_info_copy(item.type, item)
						item.count = 0
						equip[2].upd()
		Enums.ItemType.WEAPON_FIRE:
			if equip[6].item == null:
					equip[6].item = item_info_copy(item.type, item)
					item.count = 0
					equip[6].upd()
			elif equip[7].item == null:
				equip[7].item = item_info_copy(item.type, item)
				item.count = 0
				equip[7].upd()
		Enums.ItemType.HAND_WEAPON:
			if equip[4].item == null:
					equip[4].item = item_info_copy(item.type, item)
					item.count = 0
					equip[4].upd()
		_:
			for slot in inventory:
				if item.count > 0:
					if slot.item != null and slot.item.name == item.name:
						var diff = min(slot.item.max_count - slot.item.count, item.count) # минимальное количество по кол-ву айтемов
						var weight_diff: int = diff
						if item.weight_per_one != 0:
							weight_diff = int(min(player.max_weight - player.weight, diff * item.weight_per_one) / item.weight_per_one)# минимальное кол-во по весу
						var total_min_cnt = min(diff, weight_diff)
						slot.item.count += total_min_cnt
						item.count -= total_min_cnt
						item.weight = item.count * item.weight_per_one
						slot.upd()
						player.weight += total_min_cnt * item.weight_per_one
			if item.count > 0:
				for slot in inventory:
					var slot_item = slot.item
					if item.count > 0:
						if slot_item == null:
							slot_item = item_info_copy(item.type, item)
							var diff = min(item.count, item.max_count)# минимальное количество по кол-ву айтемов
							var weight_diff = diff
							if item.weight_per_one != 0:
								weight_diff = int(min(player.max_weight - player.weight, diff * item.weight_per_one) / item.weight_per_one)# минимальное кол-во по весу
							var total_min_cnt = min(diff, weight_diff)
							slot_item.count = total_min_cnt
							slot_item.weight = slot_item.count * slot_item.weight_per_one
							item.count = item.count - total_min_cnt
							item.weight = item.count * item.weight_per_one
							slot.item = slot_item
							slot.upd()
							player.weight += total_min_cnt * item.weight_per_one
	if item.count <= 0:
		item_container.queue_free()


func item_info_copy(type: int, copy: ItemInfo) -> ItemInfo:
	var new_iteminfo
	if type == Enums.ItemType.AMMO:
		new_iteminfo = Ammo.new()
		new_iteminfo.damage = copy.damage
		new_iteminfo.damage_diviation = copy.damage_diviation
		new_iteminfo.speed = copy.speed
		new_iteminfo.distance = copy.distance
		new_iteminfo.name_of_weapon = copy.name_of_weapon
	if type == Enums.ItemType.WEAPON_FIRE:
		new_iteminfo = WeaponFire.new()
		new_iteminfo.damage = copy.damage
		new_iteminfo.damage_deviation = copy.damage_deviation
		new_iteminfo.speed = copy.speed
		new_iteminfo.distance = copy.distance
		new_iteminfo.delta_time_recharge = 0
		new_iteminfo.delta_time_between = 0
		new_iteminfo.can_shot = copy.can_shot
		new_iteminfo.recharging = copy.recharging
		new_iteminfo.time_between_shot = copy.time_between_shot
		new_iteminfo.reload_time = copy.reload_time
		new_iteminfo.magazine = copy.magazine
		new_iteminfo.ammo_in_magazine = copy.ammo_in_magazine
		new_iteminfo.accuracy = copy.accuracy
		new_iteminfo.animation = copy.animation.duplicate()
	if type == Enums.ItemType.HAND_WEAPON:
		new_iteminfo = HandWeapon.new()
		new_iteminfo.time_between_hit = copy.time_between_hit
		new_iteminfo.damage = copy.damage
		new_iteminfo.delta_time_between = copy.delta_time_between
	if type == Enums.ItemType.EAT:
		new_iteminfo = Food.new()
		new_iteminfo.hunger = copy.hunger
		new_iteminfo.thirst = copy.thirst
		new_iteminfo.health = copy.health
	if type == Enums.ItemType.DRESS:
		new_iteminfo = Dress.new()
		new_iteminfo.dress_type = copy.dress_type
		new_iteminfo.slots_count = copy.slots_count
		new_iteminfo.cold_resistance = copy.cold_resistance
		new_iteminfo.armoring = copy.armoring
		new_iteminfo.animation = copy.animation.duplicate()
		new_iteminfo.max_carry_weight = copy.max_carry_weight
	new_iteminfo.name = copy.name
	new_iteminfo.description = copy.description
	new_iteminfo.icon_inventory = copy.icon_inventory.duplicate()
	new_iteminfo.icon_world = copy.icon_world.duplicate()
	new_iteminfo.type = copy.type
	new_iteminfo.count = copy.count
	new_iteminfo.max_count = copy.max_count
	new_iteminfo.weight = copy.weight
	new_iteminfo.weight_per_one = copy.weight_per_one
	new_iteminfo.stackable = copy.stackable
	new_iteminfo.destrouble = copy.destrouble
	new_iteminfo.destroying_value = copy.destroying_value
	new_iteminfo.destroying = copy.destroying

	return new_iteminfo

func _on_update_items_menu(item_near):
	while item_on_ground.get_child_count() > 0:
			var child =item_on_ground.get_child(0)
			item_on_ground.remove_child(child)
			child.queue_free()
	for itm in item_near:
		var txt = itm.item_info.name + " "
		if itm.item_info.destrouble:
			txt += str(itm.item_info.destroying * 100) + "%"
		else:
			txt += str(itm.item_info.count)
		var iii = load("res://scenes/game/inventory/list_item.tscn").instantiate()
		iii.texture = itm.item_info.icon_inventory
		iii.player = player
		iii.item_container = itm
		iii.get_child(0).text = txt
		item_on_ground.add_child(iii)
