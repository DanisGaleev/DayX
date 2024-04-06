extends Control
class_name Inventory
var inventory = []
var equip = []

@onready var grid_inventory = $Inventory/InventoryGrid
@onready var grid_equip = $EquipInv/Control
@onready var item_on_ground = $ItemsList/VBoxContainer
var player

func _ready():
	for cell in grid_inventory.get_children():
		cell.player = player
		inventory.append(cell)
	for celll in grid_equip.get_children():
		celll.player = player
		equip.append(celll)
	player.item_detected.connect(_on_update_items_menu)
func _input(event):
	if event.is_action_pressed("inventory"):
		visible = not visible
		
func _on_update_items_menu(item_near):
	# clean items_menu
	while item_on_ground.get_child_count() > 0:
			var child = item_on_ground.get_child(0)
			item_on_ground.remove_child(child)
			child.queue_free()
	
	# add new items to items_menu
	for item in item_near:
		var text_info = item.item_info.name + " "
		if item.item_info.destrouble:
			text_info += str(item.item_info.destroying * 100) + "%"
		else:
			text_info += str(item.item_info.count)
		var list_item = load("res://scenes/game/inventory/list_item.tscn").instantiate()
		list_item.texture = item.item_info.icon_inventory
		list_item.player = player
		list_item.item_container = item
		list_item.get_child(0).text = text_info
		item_on_ground.add_child(list_item)
