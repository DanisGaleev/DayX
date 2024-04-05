class_name Food extends ItemInfo

var hunger: int
var thirst: int
var health: int

func _init(item_pattern=null, count=1, destroying=0):
	super(item_pattern, count, 0)
	if item_pattern:
		self.hunger = item_pattern.hunger
		self.thirst = item_pattern.thirst
		self.health = item_pattern.health
	
func _use(_args): #eat or drink
	var player = _args[0]
	player.hunger += self.hunger
	player.thirst += self.thirst
	player.health += self.health

func _get_info():
	var desc = "Hunger reduction: %s\nThirst reduction: %s\nHealth increase: %s"
	return super() + desc % [hunger, thirst, health]
