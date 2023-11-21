class_name Food
extends ItemInfo

var hunger: int
var thirst: int
var health: int

func create(item_pattern, count=1, destroying=0):
	.create(item_pattern, count, 0)
	self.hunger = item_pattern.hunger
	self.thirst = item_pattern.thirst
	self.health = item_pattern.health
	
func use(args): #eat o drink
	var player = args[0]
	player.hunger += self.hunger
	player.thirst += self.thirst
	player.health += self.health
