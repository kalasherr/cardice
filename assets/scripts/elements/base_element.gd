extends Node2D
class_name BaseElement

var sprite_path
var value
var value_range
var sprite_node
func _ready():
	variables_change()
	build_core()
	init()

func _process(delta):
	pass

func build_core():
	var core = get_node("Core")
	var sprite = Sprite2D.new()
	sprite.name = "MainSprite"
	sprite.texture = load(sprite_path)
	core.add_child(sprite)

func rewrite_core():
	pass

func build_add():
	pass

func variables_change():
	pass

func init():
	pass

func roll():
	value = round(randf_range(value_range[0],value_range[1]))

func move(vector):
	var speed = 0
	while (vector-global_position).length() != 0:
		print(speed)
		if speed < (global_position - vector).length()/20:
			speed += 0.5
			global_position += (vector-global_position).normalized() * speed
		else:
			global_position += (vector-global_position)/20
		if (global_position - vector).length() < 1:
			global_position = vector
		await get_tree().process_frame
	
