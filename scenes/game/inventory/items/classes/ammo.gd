extends ItemInfo

class_name Ammo
var damage
var damage_diviation

var speed
var distance
var name_of_weapon

func _init(item_pattern=null, count=1, destroying=0):
	super(item_pattern, count, 0)
	if item_pattern:
		self.damage = item_pattern.damage
		self.damage_diviation = item_pattern.damage_diviation
		self.speed = item_pattern.speed
		self.distance = item_pattern.distance
		self.name_of_weapon = item_pattern.name_of_weapon
		
func _use(_args): #add ammo to magazine
	var weapon = _args[0].weapon_fire_1
	print(weapon)
	if weapon != null and weapon.name in name_of_weapon:
		var can_add = min(weapon.magazine - weapon.ammo_in_magazine, self.count)
		weapon.ammo_in_magazine += can_add
		weapon.damage = damage
		weapon.damage_deviation = damage_diviation
		weapon.speed = speed
		weapon.distance = distance
		self.count -= can_add
		weapon.recharging = true
	weapon = _args[0].weapon_fire_2
	if weapon != null and weapon.name in name_of_weapon:
		var can_add = min(weapon.magazine - weapon.ammo_in_magazine, self.count)
		weapon.ammo_in_magazine += can_add
		weapon.damage = damage
		weapon.damage_deviation = damage_diviation
		weapon.speed = speed
		weapon.distance = distance
		self.count -= can_add
		weapon.recharging = true
	_args[1].upd()

func _get_info():
	var desc = "Damage: %s\nSpeed: %s\nDamage diviation: %s\nDistance: %s\n"
	desc = desc % [damage, speed, damage_diviation, distance]
	desc += "Supported weapon:\n"
	for nm in name_of_weapon:
		desc += "    " + nm + '\n'
	return "%s%s" % [super(), desc]
