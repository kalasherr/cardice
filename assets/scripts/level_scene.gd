extends Node2D

var element_name
var pressed_button = null
var chosen_elements = []
var positions = []
var elements_result = 0
var progress = Global.progress
var energy = Global.energy
var round_count = 4
var win_indicator = ""
var ended = false
func _ready():
	define_positions()
	$LevelCamera/CanvasLayer/RU/Label2.text = "Rounds left: " + str(round_count)
	$LevelCamera/CanvasLayer/LU/Label.text = "Level " + str(Global.current_level)
	$LevelCamera.progress_bar.get_node("Label").text = str(progress)
	$LevelCamera.energy_bar.max_value = energy
	$LevelCamera.energy_bar.value = energy
	$LevelCamera.energy_bar.get_node("Label").text = str($LevelCamera.energy_bar.max_value)
	#add_element("domino",true,2,6)
	#add_element("card",true)
	#add_element("dice",true)

func _process(delta):
	for element in get_node("Elements").get_children():
		if chosen_elements.find(element) == -1:
			element.get_node("Core/Highlight").modulate = Color(1,1,1,0)
		else:
			element.get_node("Core/Highlight").modulate = Color(1,1,1,1)
	$LevelCamera/CanvasLayer/LU/Label.text = "Level " + str(Global.current_level)

func press_button(button):
	if button != "confirm" and button != "add" and button != "end":
		$Audio/Choose.play()
	if button == "confirm":
		print("confirm")
		if pressed_button == "saw" and len(chosen_elements) == 1:
			chosen_elements[0].saw()
		if pressed_button == "merge" and len(chosen_elements) == 2 and chosen_elements[0] != chosen_elements[1]:
			if chosen_elements[1].mergeable(chosen_elements[0]):
				chosen_elements[0].merge(chosen_elements[1])
			else:
				chosen_elements = []
		if pressed_button == "morph" and len(chosen_elements) == 2 and chosen_elements[0] != chosen_elements[1]:
			chosen_elements[0].morph(chosen_elements[1])
			chosen_elements = []
	pressed_button = null
	if button == "saw":
		pressed_button = "saw"
		print("saw")
		chosen_elements = []
	if button == "merge":
		pressed_button = "merge"
		print("merge")
		chosen_elements = []
	if button == "morph":
		pressed_button = "morph"
		print("morph")
		chosen_elements = []
	if button == "end":
		end_round()
	if button == "add":
		var randomizer = int(round(randf_range(0.51,3.49)))
		var text = ""
		if randomizer == 1:
			text = "dice"
		elif randomizer == 2:
			text = "domino"
		elif randomizer == 3:
			text = "card"
		if add_element(text,true):
			update_energy(6)
func add_element(element,rolled,value1 = 0,value2 = 0):
	if len(get_node("Elements").get_children()) < 10:
		$Audio/Add.play()
		var element_node = load("res://assets/scenes/elements/"+element+".tscn").instantiate()
		element_node.variables_change()
		if rolled:
			element_node.roll()
		elif element_node is not Domino:
			element_node.value = value1
		else:
			element_node.value1 = value1
			element_node.value2 = value2
		get_node("Elements").add_child(element_node)
		element_node.position = Vector2(-1500,0)
		element_node.move(positions[get_node("Elements").get_children().find(element_node)])
		element_node.init()
		return true
	return false

func define_positions():
	for i in range(2):
		for j in range(5):
			positions.append(Vector2(j*150-300,i*250-100))
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

func random_element():
	return ["dice","domino","card"].pick_random()

func end_round():
	round_count -= 1
	$LevelCamera/CanvasLayer/RU/Label2.text = "Rounds left: " + str(round_count)
	elements_result = 0
	for a in get_node("LevelCamera").button_container.get_children():
		a.disabled = true
	$LevelCamera.new_element.disabled = true
	for element in get_node("Elements").get_children():
		elements_result += element.count_result()
		$Audio/Count.play()
		await element.jump()
	print(elements_result)
	var speed = 1
	for a in range(30):
		for node in get_node("Elements").get_children():
			node.position.x += speed
			speed += 2
		await get_tree().process_frame
	for node in get_node("Elements").get_children():
		update_progress(node.count_result())
		node.queue_free()
	if win_indicator == "" and round_count <= 0:
		end_game(false)
	if win_indicator == "":
		for a in get_node("LevelCamera").button_container.get_children():
			a.disabled = false
		$LevelCamera.new_element.disabled = false
	update_energy(-1)
	

func update_progress(value):
	progress -= value
	if progress < 0:
		progress = 0
		win_indicator = "win"
		if !ended:
			ended = true
			end_game(true)
	$LevelCamera.progress_bar.get_node("Label").text = str(progress)

func update_energy(value = 1):
	if value == -1:
		$LevelCamera.energy_bar.value = $LevelCamera.energy_bar.max_value
		$LevelCamera.energy_bar.get_node("Label").text = str($LevelCamera.energy_bar.max_value)
	else:
		$LevelCamera.energy_bar.value -= value
		$LevelCamera.energy_bar.get_node("Label").text = str($LevelCamera.energy_bar.value)
	if $LevelCamera.energy_bar.value <= 0:
		$LevelCamera.energy_bar.value = 0
		for a in get_node("LevelCamera").button_container.get_children():
			a.disabled = true
		#$LevelCamera.new_element.disabled = true

func end_game(win):
	print(12)
	var label = $LevelCamera/CanvasLayer/MidT/Label
	var speed = 10
	if win:
		win_indicator = "win"
		label.text = "V I C T O R Y"
		label.modulate = Color.SEA_GREEN
		for a in get_node("LevelCamera").button_container.get_children():
			a.disabled = true
		$LevelCamera.new_element.disabled = true
		Global.current_level += 1
		Global.update()
		energy = Global.energy
		progress = Global.progress
	else:
		win_indicator = "defeat"
		label.text = "D E F E A T"
		label.modulate = Color.DARK_RED
		for a in get_node("LevelCamera").button_container.get_children():
			a.disabled = true
		
		
	$LevelCamera.new_element.disabled = true
	while label.global_position.y <= 300:
		label.position.y += speed
		await get_tree().process_frame
	await get_tree().create_timer(4).timeout
	if win:
		get_parent().add_child(load("res://assets/scenes/level_scene.tscn").instantiate())
	else:
		get_tree().root.add_child(load("res://assets/scenes/Menu.tscn").instantiate())
	free()
