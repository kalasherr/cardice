extends Node2D

var element_name
var pressed_button = null
var chosen_elements = []
var positions = []

func _ready():
	define_positions()
	for i in range(9):
		add_element("dice",true)

func _process(delta):
	pass

func press_button(button):
	if button == "confirm":
		print("confirm")
		if pressed_button == "saw" and len(chosen_elements) == 1:
			chosen_elements[0].saw()
	pressed_button = null
	if button == "saw":
		pressed_button = "saw"
		print("saw")
		chosen_elements = []

func add_element(element,rolled,value = 0):
	if len(get_node("Elements").get_children()) < 10:
		var element_node = load("res://assets/scenes/elements/"+element+".tscn").instantiate()
		element_node.variables_change()
		if rolled:
			element_node.roll()
		get_node("Elements").add_child(element_node)
		element_node.position = Vector2(0,-500)
		element_node.move(positions[get_node("Elements").get_children().find(element_node)])
		element_node.init()

func define_positions():
	for i in range(2):
		for j in range(5):
			positions.append(Vector2(j*150-300,i*200-100))
	print(positions)

func rebalance():
	for a in get_node("Elements").get_children():
		a.move(positions[get_node("Elements").get_children().find(a)])

func delete(element):
	element.queue_free()
	await get_tree().create_timer(get_process_delta_time()).timeout
	rebalance()

func check_moving():
	for a in get_node("Elements").get_children():
		if a.moving:
			return false
	return true
