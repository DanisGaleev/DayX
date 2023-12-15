extends Sprite2D

@export var arr: Array[String]

var item_info: ItemInfo
var items: Array

func _ready():
	seed(global_position.x + global_position.y - global_position.length() + global_position.angle())
	randomize()
	print(arr.size())
	var dict: Dictionary
	for i in arr:
		var x = i.split(";")
		dict[x[0]] = float(x[1])
		for j in range(float(x[1]) * 100):
			items.append([x[0], x[2]])
	prints(arr.size(), items.size())
	var itm = randi() % items.size()
	match items[itm][1]:
		"WeaponFire":
			self.item_info = WeaponFire.new()
			self.item_info.create(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
		"HandWeapon":
			self.item_info = HandWeapon.new()
			self.item_info.create(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
		"Food":
			self.item_info = Food.new()
			self.item_info.create(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
		"Ammo":
			self.item_info = Ammo.new()
			self.item_info.create(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
	texture = item_info.icon_world
		
