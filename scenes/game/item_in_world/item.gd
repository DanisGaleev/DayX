extends Sprite2D

@export var arr: Array[String]

var item_info: ItemInfo
var items: Array

func _ready():
	var dict: Dictionary
	for i in arr:
		var x = i.split(";")
		for j in range(float(x[1]) * 100):
			if len(x) > 4:
				items.append([x[0], x[2], x[3], x[4]])
			else:
				items.append([x[0], x[2], x[3]])
	if items.size() > 0:
		var itm = randi() % items.size()
		match items[itm][1]:
			"WeaponFire":
				self.item_info = WeaponFire.new(load("res://assets/item_patterns/firearm/" + items[itm][0] + ".tres"), int(items[itm][2]))
			"HandWeapon":
				self.item_info = HandWeapon.new(load("res://assets/item_patterns/hand_weapon/" + items[itm][0] + ".tres"), int(items[itm][2]))
			"Food":
				self.item_info = Food.new(load("res://assets/item_patterns/food/" + items[itm][0] + ".tres"), int(items[itm][2]))
			"Ammo":
				self.item_info = Ammo.new(load("res://assets/item_patterns/ammo/" + items[itm][0] + ".tres"), int(items[itm][2]))
			"Dress":
				self.item_info = Dress.new(load("res://assets/item_patterns/" + items[itm][2] + "/" + items[itm][0] + ".tres"), int(items[itm][3]))
		texture = item_info.icon_world
