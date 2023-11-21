extends Sprite

var item_info: ItemInfo

func _ready():
	randomize()
	if randi() % 2 == 0:
		self.item_info = WeaponFire.new()
		self.item_info.create(preload("res://assets/item_patterns/ak74_weapon_fire.tres"))
	else:
		self.item_info = Ammo.new()
		self.item_info.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 50, 0)
	self.texture = item_info.icon_world
