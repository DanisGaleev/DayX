extends ItemInfo

class_name WeaponFire

var bullet = preload("res://scenes/game/small_scenes/Bullet.tscn")

var time_between_shot: float
var recharge_time: float
var magazine: int
var ammo_in_magazine: int
var accuracy: float

var speed
var damage
var damage_deviation
var distance

var delta_time_recharge = 0
var delta_time_between = 0
var can_shot = false

var recharging: bool

func create(item_pattern, count=1, destroying=0, ammo_in_magazine=30):
	.create(item_pattern, count, destroying)
	self.ammo_in_magazine = ammo_in_magazine
	self.time_between_shot = item_pattern.time_between_shot
	self.recharge_time = item_pattern.recharge_time
	self.magazine = item_pattern.magazine
	self.accuracy = item_pattern.accuracy

func copy():
	var new_obj: WeaponFire
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
	new_obj.time_between_shot = self.time_between_shot
	new_obj.recharge_time = self.recharge_time
	new_obj.magazine = self.magazine
	new_obj.ammo_in_magazine = self.ammo_in_magazine
	new_obj.accuracy = self.accuracy
	new_obj.delta_time_recharge = self.delta_time_recharge
	new_obj.delta_time_between = self.delta_time_between
	new_obj.recharging = self.recharging
	new_obj.bullet = self.bullet
	return new_obj
	

func use(args): #fire
	.use(args)
	var bullet_b = bullet.instance()
	if can_shot and ammo_in_magazine > 0 and delta_time_between >= time_between_shot:
		ammo_in_magazine -= 1
		bullet_b.speed = speed
		bullet_b.damage = damage + rand_range(-damage_deviation, damage_deviation)
		bullet_b.distance = distance
		bullet_b.direction = args[0]
		bullet_b.global_position = args[1]
		args[2].add_child(bullet_b)
		delta_time_between = 0
		
func update(delta):
	.update(delta)
	if ammo_in_magazine <= 0:
		can_shot = false
	if recharging:
		delta_time_recharge += delta
		if delta_time_recharge >= recharge_time:
			can_shot = true
			recharging = false
			delta_time_recharge = 0
			ammo_in_magazine = magazine
	if can_shot:
		delta_time_between += delta

func recharge():
	print("recharge")
	recharging = true
	
	#if delta_time_recharge >= recharge_time:
	#	can_shot = true
	#	recharging = false
	#	delta_time_recharge = 0
	#	ammo_in_magazine = magazine
