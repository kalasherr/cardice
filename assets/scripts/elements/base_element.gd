extends Node2D
class_name BaseElement

var sprite_path
var value
var value_range

func _ready():
	variables_change()
	build_core()
	

func _process(delta):
	pass

func build_core():
	var core = get_node("Core")
	var sprite = Sprite2D.new()
	sprite.texture = load(sprite_path)
	core.add_child(sprite)

func rewrite_core():
	pass

func build_add():
	pass

func variables_change():
	pass
