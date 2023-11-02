extends Sprite

var item_info: ItemInfo

func _ready():
	self.item_info = Ammo.new()
	self.item_info.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 5, 0)
	self.texture = item_info.icon_world
	print(str(item_info.max_count) + "max_count")
