extends BaseElement
class_name Domino
var value1 = 2
var value2 = 1

func variables_change():
	value_range = [0,6]
	element_name = "domino"

func init():
	print([value1,value2])
	sprite_node = get_node("Core/MainSprite")
	if len(sprite_node.get_children()) > 0:
		for a in sprite_node.get_children():
			a.queue_free()
	var value1_sprite = Sprite2D.new()
	var value2_sprite = Sprite2D.new()
	if value1 != 0:
		value1_sprite.texture = load("res://assets/sprites/elements/domino/" + str(value1) + ".png")
	value1_sprite.position += Vector2(0,32)
	if value2 != 0:
		value2_sprite.texture = load("res://assets/sprites/elements/domino/" + str(value2) + ".png")
	value2_sprite.position += Vector2(0,-32)
	sprite_node.add_child(value1_sprite)
	sprite_node.add_child(value2_sprite)

func saw():
	var board = get_parent().get_parent()
	reparent(board.get_node("Buffer"))
	board.rebalance()
	if value1 != 0:
		board.add_element("dice",false,value1)
	if value2 != 0:
		board.add_element("dice",false,value2)
	get_parent().get_parent().update_energy(1)
	queue_free()

func mergeable(element):
	if element is Dice or element is Domino:
		return true
	return false

func roll():
	value1 = round(randf_range(value_range[0] - 0.49,value_range[1] + 0.49))
	value2 = round(randf_range(value_range[0] - 0.49,value_range[1] + 0.49))

func merge(element):
	var board = get_parent().get_parent()
	var result = [value1,value2]
	if element is Dice:
		var bigger_value
		self.reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		if value1 < value2:
			result[0] = int(result[0] + element.value)%7
		else:
			result[1] = int(result[1] + element.value)%7
		get_parent().get_parent().add_element("domino",false,result[0],result[1])
		element.queue_free()
		get_parent().get_parent().update_energy(1)
		self.queue_free()

	if element is Domino:
		self.reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		if value1 < value2:
			if element.value1 < element.value2:
				result[0] = int(value1 + element.value2)%7
				result[1] =  int(element.value1 + value2)%7
			else:
				result[0] = int(value1 + element.value1)%7
				result[1] = int(value2 + element.value2)%7
		else:
			if not element.value1 < element.value2:
				result[0] = int(value1 + element.value2)%7
				result[1] =  int(element.value1 + value2)%7
			else:
				result[0] = int(value1 + element.value1)%7
				result[1] = int(value2 + element.value2)%7
		get_parent().get_parent().add_element("domino",false,result[0],result[1])
		element.queue_free()
		get_parent().get_parent().update_energy(1)
		self.queue_free()

func sum6(num1,num2):
	if num1 + num2 > 6:
		return 6
	return num1 + num2

func morph(element):
	var result = 0
	var board = get_parent().get_parent()
	if element is Domino and self is Domino:
		self.reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		
		result = element.value1 + element.value2 + value1 + value2
		print(result)
		var result1 = split(result,-0.49,12.49)
		var result2 = result - result1
		print([result1,result2])
		while result1 > 12 or result1 < 0 or result2 > 12 or result2 < 0:
			result1 = split(result,-0.49,12.49)
			result2 = result - result1
		var result11 = split(result1,-0.49,6.49)
		var result12 = result1 - result11
		while result11 > 6 or result11 < 0 or result12 > 6 or result12 < 0:
			result11 = split(result1,-0.49,6.49)
			result12 = result1 - result11
		board.add_element("domino",false,result11,result12)
		print(result2)
		result1 = result2
		result11 = split(result,-0.49,6.49)
		result12 = result1 - result11
		while result11 > 6 or result11 < 0 or result12 > 6 or result12 < 0:
			result11 = split(result1,-0.49,6.49)
			result12 = result1 - result11
		board.add_element("domino",false,result11,result12)
		get_parent().get_parent().update_energy(1)
		element.queue_free()
		queue_free()
		
func split(result,range1,range2):
	var result1 = round(randf_range(range1,range2))
	var result2 = result - result1
	while result2 < 0:
		result1 -= 1
		result2 += 1
	while result1 < 0:
		result1 += 1
		result2 -= 1
	return result1

func count_result():
	var value1_found = false
	var value2_found = false
	var multiplier = 3
	for element in get_parent().get_parent().get_node("Elements").get_children():
		if element is Domino:
			if element.value1 + element.value2 == value1:
				value1_found = true
			if element.value1 + element.value2 == value2:
				value2_found = true
		else:
			if element.value == value1:
				value1_found = true
			if element.value == value2:
				value2_found = true
	if value1_found and value2_found:
		return abs(value1 + value2) * multiplier
	else:
		return abs(value1 + value2)

func get_text():
	if element_name == "domino":
		return "x3 points if there is \n" + str(abs(value1)) + " and " + str(abs(value2)) + " on the desk"
