extends Node2D
class_name BaseElement

var sprite_path
var element_name
var button_texture_path
var value = 1
var value_range
var sprite_node
var moving = false
func _ready():
	variables_change()
	base_changes()
	build_core()


func _process(delta):
	pass

func build_core():
	var core = get_node("Core")
	var sprite = Sprite2D.new()
	sprite.name = "MainSprite"
	sprite.texture = load(sprite_path)
	core.add_child(sprite)
	var button = TextureButton.new()
	button.name = "Button"
	button.position = -sprite.texture.get_size()/2
	button.texture_click_mask = load(button_texture_path)
	button.connect("pressed", choose)
	core.add_child(button)

func rewrite_core():
	pass

func choose():
	var board = get_parent().get_parent()
	if board.check_moving():
		if board.pressed_button == "saw" or board.pressed_button == "reroll":
			if board.chosen_elements == []:
				board.chosen_elements.append(self)
			else:
				board.chosen_elements = []
				board.pressed_button = null

func build_add():
	pass

func variables_change():
	pass

func base_changes():
	sprite_path = "res://assets/sprites/elements/"+element_name+"/core.png"
	button_texture_path = "res://assets/sprites/elements/"+element_name+"/button.png"

func init():
	pass

func roll():
	value = round(randf_range(value_range[0] - 0.49,value_range[1] + 0.49))

func move(vector):
	moving = true
	while (vector-global_position).length() != 0:
		if (vector-global_position).length()/10 > 0.5:
			global_position += (vector-global_position)/10
		elif (vector-global_position).length() > 0.5:
			global_position += (vector-global_position).normalized() * 0.5
		else:
			global_position = vector
		await get_tree().process_frame
	moving = false
			
	#while (vector-global_position).length() != 0:
		#if speed < (global_position - vector).length()/20:
			#speed += 0.5
			#global_position += (vector-global_position).normalized() * speed
		#else:
			#global_position += (vector-global_position)/20
		#if (global_position - vector).length() < 1:
			#global_position = vector
		#await get_tree().process_frame

func saw():
	pass

func combine():
	pass

func reroll():
	pass

func morph():
	pass
