extends ItemInfo

class_name WeaponFire

var bullet = preload("res://scenes/game/small_scenes/Bullet.tscn")

var time_between_shot: float
var reload_time: float
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

func _init(item_pattern=null, count=1, destroying=0, _ammo_in_magazine=0):
	if item_pattern:
		super(item_pattern, count, destroying)
		ammo_in_magazine = _ammo_in_magazine
		if ammo_in_magazine > 0:
			can_shot = true
		self.time_between_shot = item_pattern.time_between_shot
		self.reload_time = item_pattern.reload_time
		self.magazine = item_pattern.magazine
		self.accuracy = item_pattern.accuracy

func equip(args): #equip
	var player = args[0]
	var slot = args[1]
	if player.weapon_fire_1 == null:
		player.weapon_fire_1 = self
		player.inventory.equip[0].item = self
		player.inventory.equip[0].upd()
		slot.item = null
		slot.upd()
	elif args[0].weapon_fire_2 == null:
		args[0].weapon_fire_2 = self
		args[0].inventory.equip[1].item = self
		args[0].inventory.equip[1].upd()
		args[1].item = null
		args[1].upd()
	if player.weapon_fire_1:
		player.animations_dictionary["WeaponFire1Animation"].sprite_frames = animation
	if player.weapon_fire_2:
		player.animations_dictionary["WeaponFire2Animation"].sprite_frames = animation
	
func fire(args): #fire
	if can_shot and ammo_in_magazine > 0 and delta_time_between >= time_between_shot:
		self.destroy([args[2].get_node("Player"), args[3], args[2]])
		var bullet_b = bullet.instantiate()
		ammo_in_magazine -= 1
		bullet_b.speed = speed
		bullet_b.damage = damage + randf_range(-damage_deviation, damage_deviation)
		bullet_b.distance = distance
		bullet_b.direction = args[0]
		bullet_b.global_position = args[1]
		args[2].add_child(bullet_b)
		delta_time_between = 0
		prints("weapon", destroying)
		
		args[2].get_node("Player").noise_level = 20.0
		await args[2].get_tree().create_timer(0.1).timeout
		args[2].get_node("Player").noise_level = 0.0
	
func _update(delta):
	if ammo_in_magazine <= 0:
		can_shot = false
	if recharging:
		delta_time_recharge += delta
		if delta_time_recharge >= reload_time:
			can_shot = true
			recharging = false
			delta_time_recharge = 0
	if can_shot:
		delta_time_between += delta

func recharge(inventory):
	for i in inventory.inventory:
		if i.item != null and (i.item is Ammo) and (self.name in i.item.name_of_weapon):
			i.item._use([inventory.player, i])
			i.upd()
			recharging = true
			break
			
func _get_info():
	var desc = "Fire rate: %s\nReload time: %s\nMagazine: %s\nAccuracy: %s"
	desc = desc % [time_between_shot, reload_time, magazine, accuracy]
	return super() + desc
