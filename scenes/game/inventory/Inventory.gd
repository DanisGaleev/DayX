extends TextureRect
class_name Inventory
export var inventory = []

onready var grid = $InventoryGrid

func _ready():
	for i in grid.get_children():
		inventory.append(i)
func _input(event):
	if event.is_action_pressed("inventory"):
		visible = not visible
		
func add_item(item: ItemInfo, item_container: Sprite):
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
					#var t = []
					#t.append(item)
					#slot_item = t.duplicate()
					#print("mx: " + str(item.max_count))
					#slot_item = item.duplicate(2)
					#slot_item.icon_inventory = item.icon_inventory.duplicate()
					#slot_item.icon_world = item.icon_world.duplicate()
	
					slot_item = item_info_copy(item.get_script().get_path(), item)
					var diff = min(item.count, item.max_count)
					#slot_item[0].count = diff
					slot_item.count = diff
					item.count -= diff
					slot.item = slot_item
					print("slot max_count: " + str(slot.item.max_count))
					slot.upd()
	if item.count <= 0:
		item_container.queue_free()


func item_info_copy(name: String, copy: ItemInfo) -> ItemInfo:
	var new_iteminfo
	if name.find("Ammo") != -1:
		new_iteminfo = Ammo.new()
		new_iteminfo.damage = copy.damage
		new_iteminfo.damage_diviation = copy.damage_diviation
		new_iteminfo.speed = copy.speed
		new_iteminfo.distance = copy.distance
	if name.find("WeaponFire") != -1:
		new_iteminfo = WeaponFire.new()
		new_iteminfo.damage = copy.damage
		new_iteminfo.damage_diviation = copy.damage_diviation
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
	new_iteminfo.nname = copy.nname
	new_iteminfo.description = copy.description
	new_iteminfo.icon_inventory = copy.icon_inventory.duplicate()
	new_iteminfo.icon_world = copy.icon_world.duplicate()
	new_iteminfo.count = copy.count
	new_iteminfo.max_count = copy.max_count
	new_iteminfo.stackable = copy.stackable
	new_iteminfo.destrouble = copy.destrouble
	new_iteminfo.destroying_value = copy.destroying_value
	new_iteminfo.destroying = copy.destroying
	
	return new_iteminfo
