extends Control
class_name Inventory
var inventory = []
var equip = []

@onready var grid_inventory = $Inventory/InventoryGrid
@onready var grid_equip = $Equip/EquipGrid
var player

func _ready():
	for i in grid_inventory.get_children():
		i.player = player
		inventory.append(i)
	for j in grid_equip.get_children():
		j.player = player
		equip.append(j)
func _input(event):
	if event.is_action_pressed("inventory"):
		visible = not visible
		
func add_item(item: ItemInfo, item_container: Sprite2D):
	for slot in inventory:
		if item.count > 0:
			if slot.item != null and slot.item.name == item.name:
				var diff = min(slot.item.max_count - slot.item.count, item.count)
				print(str(slot.item.max_count) + " " + str(slot.item.count) + " " + str(item.count))
				slot.item.count += diff
				item.count -= diff
				print(item.count)
				slot.upd()
	if item.count > 0:
		for slot in inventory:
			var slot_item = slot.item
			if item.count > 0:
				if slot_item == null:
					slot_item = item_info_copy(item.type, item)
					var diff = min(item.count, item.max_count)
					slot_item.count = diff
					item.count -= diff
					slot.item = slot_item
#					for i in slot.item.get_property_list():
#						print(i)
#						print(i, slot.item.get(i))
					slot.upd()
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
		new_iteminfo.recharge_time = copy.recharge_time
		new_iteminfo.magazine = copy.magazine
		new_iteminfo.ammo_in_magazine = copy.ammo_in_magazine
		new_iteminfo.accuracy = copy.accuracy
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
	new_iteminfo.name = copy.name
	new_iteminfo.description = copy.description
	new_iteminfo.icon_inventory = copy.icon_inventory.duplicate()
	new_iteminfo.icon_world = copy.icon_world.duplicate()
	new_iteminfo.type = copy.type
	new_iteminfo.count = copy.count
	new_iteminfo.max_count = copy.max_count
	new_iteminfo.stackable = copy.stackable
	new_iteminfo.destrouble = copy.destrouble
	new_iteminfo.destroying_value = copy.destroying_value
	new_iteminfo.destroying = copy.destroying
	
	return new_iteminfo
