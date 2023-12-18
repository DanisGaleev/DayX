extends Node2D

func _ready():
	for spawn in $ItemsSpawnPositions.get_children():
		var item = preload("res://scenes/game/items_in_world/item.tscn").instantiate()
		item.position = spawn.position
		print(item.is_in_group("item_world"))
		add_child(item)

func _on_in_trigger_body_entered(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible


func _on_in_trigger_body_exited(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible

