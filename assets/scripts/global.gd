extends Node
var current_level = 1
var energy = 20 * (current_level + 1)
var progress = 150 * (current_level + 1)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_menu():
	pass

func update():
	energy = 20 * (current_level + 1)
	progress = 150 * (current_level + 1)
