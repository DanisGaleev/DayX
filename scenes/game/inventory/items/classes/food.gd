class_name Food
extends ItemInfo

var hunger: int
var thirst: int
var health: int

func _init(item_pattern=null, count=1, destroying=0):
	super._init(item_pattern, count, 0)
	if item_pattern:
		self.hunger = item_pattern.hunger
		self.thirst = item_pattern.thirst
		self.health = item_pattern.health
	
func use(args): #eat o drink
	var player = args[0]
	player.hunger += self.hunger
	player.thirst += self.thirst
	player.health += self.health

func get_info():
	var desc = "Hunger reduction: %s\nThirst reduction: %s\nHealth increase: %s"
	return super.get_info() + desc % [hunger, thirst, health]
