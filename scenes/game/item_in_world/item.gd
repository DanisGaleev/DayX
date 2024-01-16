extends Sprite2D

@export var arr: Array[String]

var item_info: ItemInfo
var items: Array

func _ready():
	seed(global_position.x + global_position.y - global_position.length() + global_position.angle())
	randomize()
	var dict: Dictionary
	print(arr)
	for i in arr:
		var x = i.split(";")
		dict[x[0]] = float(x[1])
		for j in range(float(x[1]) * 100):
			if len(x) > 3:
				items.append([x[0], x[2], x[3]])
			else:
				items.append([x[0], x[2]])
	var itm = randi() % items.size()
	match items[itm][1]:
		"WeaponFire":
			self.item_info = WeaponFire.new(load("res://assets/item_patterns/firearm/" + items[itm][0] + ".tres"))
			#self.item_info.create()
		"HandWeapon":
			self.item_info = HandWeapon.new(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
			#self.item_info.(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
		"Food":
			self.item_info = Food.new(load("res://assets/item_patterns/" + items[itm][0] + ".tres"))
		"Ammo":
			self.item_info = Ammo.new(load("res://assets/item_patterns/ammo/" + items[itm][0] + ".tres"), 40)
		"Dress":
			self.item_info = Dress.new(load("res://assets/item_patterns/" + items[itm][2] + "/" + items[itm][0] + ".tres"))
	texture = item_info.icon_world
