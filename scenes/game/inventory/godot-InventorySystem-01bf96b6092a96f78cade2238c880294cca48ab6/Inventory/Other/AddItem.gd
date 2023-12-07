extends Control


signal interacted(sender, item, amount)

@export var directory: Script
@export var amount: int = 1

var item


func _ready():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var _succ = connect("interacted", Callable(player, "_on_item_interacted"))
	
	if is_instance_valid(directory):
		item = directory.new()
		$Button/TextureRect.texture = item.i_image


func _on_pressed():
	if is_instance_valid(directory):
		emit_signal("interacted", self, item, amount)
