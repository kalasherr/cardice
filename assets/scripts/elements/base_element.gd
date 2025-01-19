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
	var mouse = get_global_mouse_position()
	var collision_shape = get_node("Core/Area/Collision")
	var area = get_node("Core/Area")
	if not collision_shape.shape.get_rect().has_point(area.to_local(mouse)):
		get_node("Core/Tooltip").modulate = Color(1,1,1,0)

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
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	var label = Label.new()
	label.name = "Label"
	label.text = ""
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position += Vector2(-sprite.texture.get_size().x/2,-120)
	label.custom_minimum_size = Vector2(sprite.texture.get_size().x,20)
	core.add_child(label)
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = sprite.texture.get_size()
	area.name = "Area"
	collision.name = "Collision"
	area.connect("mouse_entered", show_tooltip)
	area.connect("mouse_exited", hide_tooltip)
	area.add_child(collision)
	get_node("Core").add_child(area)
	var tooltip = load("res://assets/scenes/tooltip.tscn").instantiate()
	tooltip.name = "Tooltip"
	tooltip.position -= Vector2(0,140)
	tooltip.z_index += 1
	tooltip.get_node("Label").text = get_text()
	get_node("Core").add_child(tooltip)
	var highlight = Sprite2D.new()
	highlight.texture = load("res://assets/sprites/elements/"+element_name+"/highlight.png")
	highlight.z_index = -1
	highlight.name = "Highlight"
	get_node("Core").add_child(highlight)

func rewrite_core():
	pass

func choose():
	var board = get_parent().get_parent()
	board.get_node("Audio/Choose").play()
	if board.check_moving():
		if board.pressed_button == "saw" or board.pressed_button == "reroll":
			if board.chosen_elements == []:
				board.chosen_elements.append(self)
			else:
				board.chosen_elements = []
				board.pressed_button = null
		elif board.pressed_button == "merge":
			if len(board.chosen_elements) < 2:
				board.chosen_elements.append(self)
			else:
				board.chosen_elements = []
				board.pressed_button = null
		elif board.pressed_button == "morph":
			if len(board.chosen_elements) < 2:
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

func merge(element):
	pass

func mergeable(element):
	return false

func reroll():
	pass

func morph(element):
	if element is not Domino:
		var array = []
		var count = []
		var result = value + element.value
		var result_self
		var result_element
		if element.value_range[1] < value_range[1]:
			result_element = round(randf_range(element.value_range[0]-0.49,element.value_range[1]+0.49))
			result_self = result - result_element
		else:
			result_self = round(randf_range(value_range[0]-0.49,value_range[1]+0.49))
			result_element = result - result_self
		while result_self < value_range[0] or result_element > element.value_range[1]:
			result_element -= 1
			result_self += 1
		while result_self > value_range[1] or result_element < element.value_range[0]:
			result_element += 1
			result_self -= 1
		var board = get_parent().get_parent()
		reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		board.add_element(element_name,false,result_self)
		board.add_element(element.element_name,false,result_element)
		get_parent().get_parent().update_energy(1)
		element.queue_free()
		queue_free()
		
func count_result():
	return 0

func jump():
	var pos = position
	var speed = -12
	while true:
		await get_tree().process_frame
		speed += 1
		if speed >= 12:
			break
		position += speed * Vector2(0,1)
	get_node("Core/Label").text = str(count_result())
	await get_tree().create_timer(get_process_delta_time() * 5).timeout
	
		
func highlight():
	pass

func show_tooltip():
	for a in range(11):
		get_node("Core/Tooltip").modulate = Color(1,1,1,float(a)/10)
		await get_tree().process_frame

func hide_tooltip():
	get_node("Core/Tooltip").modulate = Color(1,1,1,0)

func get_text():
	if element_name == "dice":
		return "+0.5 multiplier\n for each Dice"
	if element_name == "card":
		return "+2 for each non-Card"
