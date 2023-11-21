extends ItemInfo

class_name Ammo
var damage
var damage_diviation

var speed
var distance
var name_of_weapon

func create(item_pattern, count=1, destroying=0):
	.create(item_pattern, count, 0)
	self.damage = item_pattern.damage
	self.damage_diviation = item_pattern.damage_diviation
	self.speed = item_pattern.speed
	self.distance = item_pattern.distance
	self.name_of_weapon = item_pattern.name_of_weapon
	
func use(args): #add ammo to magazine
	var weapon = args[0]
	var added = weapon.magazine - weapon.ammo_in_magazine
	weapon.ammo_in_magazine +=  min(self.count, added) 
	weapon.damage = damage
	weapon.damage_deviation = damage_diviation
	weapon.speed = speed
	weapon.distance = distance
	self.count -= added
