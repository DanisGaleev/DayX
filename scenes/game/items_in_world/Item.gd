extends Sprite

var item_info: ItemInfo

func _ready():
	randomize()
	print(preload("res://assets/item_patterns/ak74_weapon_fire.tres").max_count)
	if randi() % 1 == 0:
		self.item_info = WeaponFire.new()
		self.item_info.create(preload("res://assets/item_patterns/weapon_fire.tres"))
		self.texture = item_info.icon_world
	elif randi() % 1 == 1:
		self.item_info = Ammo.new()
		self.item_info.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 50, 0)
	else:
		self.item_info = WeaponFire.new()
		self.item_info.create(preload("res://assets/item_patterns/weapon_fire.tres"))
	self.texture = item_info.icon_world
