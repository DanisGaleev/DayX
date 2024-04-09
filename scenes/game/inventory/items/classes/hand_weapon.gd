class_name HandWeapon
extends ItemInfo

var damage: int

var time_between_hit: float
var delta_time_between = 0.0

func _init(item_pattern=null, count=1, _destroying=0):
	if item_pattern:
		super(item_pattern, count, _destroying)
		self.time_between_hit = item_pattern.time_between_hit
		self.damage = item_pattern.damage

#func equip(args): #equip on player (not equip zone)
	#var player = args[0]
	#player.hand_weapon = self
	#player.inventory.equip[2].item = self
	#player.inventory.equip[2].upd()
	#player.weight += self.weight
	#
	#args[1].item = null
	#args[1].upd()
#
	#if player.hand_weapon:
		#player.animations_dictionary["WeaponHandAnimation"].sprite_frames = animation
	
func hit(args): #hit
	if delta_time_between >= time_between_hit:
		delta_time_between = 0
		args[0].attack_animation()
		args[0].enemy_hit(args[1], damage)
		destroy([])
		args[0].noise_level = 3.0
		await args[0].get_tree().create_timer(0.1).timeout
		args[0].noise_level = 0.0

func update(delta):
	delta_time_between += delta

func get_info():
	var desc = "Cooldown time: %s\nDamage: %s" % [time_between_hit, damage]
	return super() + desc
	
func dublicate():
	var new_item_info = HandWeapon.new(item_pattern, count, destroying)
	return new_item_info
