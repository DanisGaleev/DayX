extends ItemInfo

class_name Ammo
var damage
var damage_diviation

var speed
var distance

func create(item_pattern, count=1, destroying=0):
	.create(item_pattern, count, 0)
	self.damage = item_pattern.damage
	self.damage_diviation = item_pattern.damage_diviation
	self.speed = item_pattern.speed
	self.distance = item_pattern.distance

func copy():
	var new_obj: Ammo
	new_obj.nname = self.nname
	new_obj.description = self.description
	new_obj.icon_inventory = self.icon_inventory
	new_obj.icon_world = self.icon_world
	new_obj.count = self.count
	new_obj.max_count = self.max_count
	new_obj.stackable = self.stackable
	new_obj.destrouble = self.destrouble
	new_obj.destroying_value = self.destroying_value
	new_obj.destroying = self.destroying
	
	new_obj.damage = self.damage
	new_obj.damage_diviation = self.damage_diviation
	new_obj.speed = self.speed
	new_obj.distance = self.distance
	return new_obj
	
func use(args): #fire
	.use(args)
	var weapon = args[0] as WeaponFire
	var added = weapon.magazine - weapon.ammo_in_magazine
	weapon.ammo_in_magazine =  min(self.count, weapon.magazine) 
	weapon.damage = damage
	weapon.damage_deviation = damage_diviation
	weapon.speed = speed
	weapon.distance = distance
	count -= added
