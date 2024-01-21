extends Node


@export var gui_path: NodePath = "GUI"
var health := 100
@onready var gui = get_node(gui_path)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		$InventoryComponent.toggle_window(self)
	
	# Query test by hitting 'Esc' for Apple
	if event.is_action_pressed("ui_cancel"):
		if $InventoryComponent.inv_query("Apple", 2):
			pass
		else:
			pass


func _on_item_interacted(sender, item, amount):
	if $InventoryComponent.add_to_inventory(item, amount):
		sender.queue_free()
