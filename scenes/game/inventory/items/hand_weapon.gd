class_name HandWeapon
extends ItemInfo

var time_between_hit: float
var damage: int

var delta_time_between

func create(item_pattern, count=1, destroying=0):
	super.create(item_pattern, count, destroying)
	self.time_between_hit = item_pattern.time_between_hit
	self.damage = item_pattern.damage

func equip(args): #equip on player (not equip zone)
	args[0].near_weapon == self
	
func hit(args): #hit
	if delta_time_between >= time_between_hit:
		delta_time_between = 0
		print("hit")
		args[0].attack()
		destroy()
		args[2].get_node("Player").noise_level = 3.0
		await args[2].get_tree().create_timer(0.1).timeout
		args[2].get_node("Player").noise_level = 0.0
	
func update(delta):
	delta_time_between += delta
