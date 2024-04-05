class_name HandWeapon
extends ItemInfo

var time_between_hit: float
var damage: int

var delta_time_between = 0

func _init(item_pattern=null, count=1, _destroying=0):
	if item_pattern:
		super(item_pattern, count, _destroying)
		self.time_between_hit = item_pattern.time_between_hit
		self.damage = item_pattern.damage

func equip(args): #equip on player (not equip zone)
	var player = args[0]
	
	player.hand_weapon = self
	player.inventory.equip[2].item = self
	player.inventory.equip[2].upd()
	args[1].item = null
	args[1].upd()
	player.weight += self.weight
	
	if player.hand_weapon:
		print("axe")
		player.animations_dictionary["WeaponHandAnimation"].sprite_frames = animation
	
func hit(args): #hit
	if delta_time_between >= time_between_hit:
		delta_time_between = 0
		print("hit")
		args[0].attack()
		destroy([])
		args[2].get_node("Player").noise_level = 3.0
		await args[2].get_tree().create_timer(0.1).timeout
		args[2].get_node("Player").noise_level = 0.0

func _update(delta):
	delta_time_between += delta

func _get_info():
	var desc = "Cooldown time: %s\nDamage: %s" % [time_between_hit, damage]
	return super() + desc
