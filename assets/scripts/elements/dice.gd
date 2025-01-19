extends BaseElement
class_name Dice

func variables_change():
	value_range = [1,6]
	element_name = "dice"

func init():
	sprite_node = get_node("Core/MainSprite")
	if len(sprite_node.get_children()) == 1:
		sprite_node.remove_child(sprite_node.get_children()[0])
	var value_sprite = Sprite2D.new()
	value_sprite.texture = load("res://assets/sprites/elements/dice/" + str(value) + ".png")
	sprite_node.add_child(value_sprite)

func saw():
	var board = get_parent().get_parent()
	var values = []
	if int(value)%2 == 0:
		values.append(value/2)
		values.append(value/2)
	elif value == 1:
		self.reparent(board.get_node("Buffer"))
		board.rebalance()
		queue_free()
		return false
	else:
		values.append(value/2-0.5)
		values.append(value/2+0.5)
	
	self.reparent(board.get_node("Buffer"))
	board.rebalance()
	board.add_element("dice",false,values[0])
	board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].value = values[0]
	board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].init()
	print(values[0])
	board.add_element("dice",false,values[1])
	board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].value = values[1]
	board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].init()
	print(values[1])
	board.chosen_elements = []
	get_parent().get_parent().update_energy(1)
	queue_free()

func merge(element):
	var board = get_parent().get_parent()
	if element is Dice:
		self.reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		board.add_element("domino",false,value,element.value)
		get_parent().get_parent().update_energy(1)
		element.queue_free()
		self.queue_free()
	if element is Domino:
		var bigger_value
		self.reparent(board.get_node("Buffer"))
		element.reparent(board.get_node("Buffer"))
		board.rebalance()
		if element.value1 < element.value2:
			element.value1 = int(element.value1 + value)%7
		else:
			element.value2 = int(element.value2 + value)%7
		board.add_element("domino",false,element.value1,element.value2)
		get_parent().get_parent().update_energy(1)
		element.queue_free()
		self.queue_free()
		

func mergeable(element):
	if element is Dice or element is Domino:
		return true
	return false

func count_result():
	var counter = 1
	for element in get_parent().get_parent().get_node("Elements").get_children():
		if element is Dice and element != self:
			counter += 0.5
	return round(value * counter)
