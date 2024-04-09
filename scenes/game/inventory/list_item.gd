extends TextureRect

@export var player: Player

var item
var inventory
var equip
var item_container

func _ready():
	inventory = player.inventory.inventory
	equip = player.inventory.equip

func add_item(item, item_container, count=item.count):
	var equip_id = -1
	match item.type:
		Enums.ItemType.DRESS:
			match item.dress_type:
				Enums.DressType.ARMOR:
					equip_id = 1
				Enums.DressType.BACKPACK:
					equip_id = 3
				Enums.DressType.HEADDRESS:
					equip_id = 0
				Enums.DressType.PANTS:
					equip_id = 5
				Enums.DressType.SHIRT:
					equip_id = 2
		Enums.ItemType.WEAPON_FIRE:
			if equip[6].item == null:
				equip_id = 6
			elif equip[7].item == null:
				equip_id = 7
		Enums.ItemType.HAND_WEAPON:
			equip_id = 4
		_:
			var was_count = count
			for slot in inventory:
				if count > 0:
					if slot.item != null and slot.item.name == item.name:
						var diff = min(slot.item.max_count - slot.item.count, count) # минимальное количество по кол-ву айтемов
						var weight_diff: int = diff
						if item.weight_per_one != 0:
							weight_diff = int(min(player.max_weight - player.weight, diff * item.weight_per_one) / item.weight_per_one)# минимальное кол-во по весу
						var total_min_cnt = min(diff, weight_diff)
						slot.item.count += total_min_cnt
						count -= total_min_cnt
						item.weight = count * item.weight_per_one
						slot.upd()
						player.weight += total_min_cnt * item.weight_per_one

			if count > 0:
				for slot in inventory:
					var slot_item = slot.item
					if count > 0:
						if slot_item == null:
							slot_item = item.duplicate()
							var diff = min(count, item.max_count)# минимальное количество по кол-ву айтемов
							var weight_diff = diff
							if item.weight_per_one != 0:
								weight_diff = int(min(player.max_weight - player.weight, diff * item.weight_per_one) / item.weight_per_one)# минимальное кол-во по весу
							var total_min_cnt = min(diff, weight_diff)
							slot_item.count = total_min_cnt
							slot_item.weight = slot_item.count * slot_item.weight_per_one
							count -= total_min_cnt
							item.weight = count * item.weight_per_one
							slot.item = slot_item
							slot.upd()
							player.weight += total_min_cnt * item.weight_per_one
			item.count -= (was_count - count)

	if equip_id != -1 and equip[equip_id].item == null and item.weight <= player.max_weight - player.weight:
		equip[equip_id].item = item.dublicate()
		player.weight += item.weight
		item.count = 0
		equip[equip_id].upd()

	if item.count <= 0:
		item_container.queue_free()
		queue_free()

	player.update_player_params()

func _on_add_one_pressed():
	add_item(item_container.item_info, item_container, 1)
	player.item_detected.emit(player.item_near)

func _on_add_all_pressed():
	add_item(item_container.item_info ,item_container)
	player.item_detected.emit(player.item_near)
