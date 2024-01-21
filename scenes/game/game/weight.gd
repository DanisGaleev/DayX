extends Label
var player

func _ready():
	player = get_node("../../../World/Player")
func  _process(delta):
	text = str(player.weight) + "  " + str(player.max_weight)
