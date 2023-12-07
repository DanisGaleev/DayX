extends MarginContainer


@export var slot_scene: PackedScene

var slot_list = Array()
var inv_comp: Inventory_Component


func _ready():
	for i in range(inv_comp.inv_slots):
		var slot_child = slot_scene.instantiate()
		slot_child.slot_index = i
		$Background/InventoryGrid.add_child(slot_child)
		slot_list.append(slot_child)
	$Background/UpperOverlay/InventoryName.text = inv_comp.inv_name


func _on_CloseButton_pressed():
	queue_free()
