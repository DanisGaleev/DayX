extends Sprite2D

var item_info: ItemInfo

func _ready():
	randomize()
	if randi() % 3 == 0:
		self.item_info = WeaponFire.new()
		self.item_info.create(preload("res://assets/item_patterns/m4_weapon_fire.tres"))
	elif randi() % 3 == 1:
		self.item_info = Ammo.new()
		self.item_info.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 50, 0)
	else:
		self.item_info = WeaponFire.new()
		self.item_info.create(preload("res://assets/item_patterns/ak74_weapon_fire.tres"))
	self.texture = item_info.icon_world
