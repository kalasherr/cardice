extends BaseElement
class_name Card
func variables_change():
	value_range = [2,14]
	element_name = "card"

func init():
	sprite_node = get_node("Core/MainSprite")
	if len(sprite_node.get_children()) == 1:
		sprite_node.remove_child(sprite_node.get_children()[0])
	var value_sprite = Sprite2D.new()
	value_sprite.texture = load("res://assets/sprites/elements/card/" + str(value) + ".png")
	sprite_node.add_child(value_sprite)

func saw():
	var board = get_parent().get_parent()
	if value > 3:
		
		var result1 = 2
		var result2 = value - 2
		result1 = int(round(randf_range(1.51,value-2.49)))
		result2 = value - result1
		self.reparent(board.get_node("Buffer"))
		board.rebalance()
		board.add_element("card",false,result2)
		board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].init()

		board.add_element("card",false,result1)
		board.get_node("Elements").get_children()[len(board.get_node("Elements").get_children())-1].init()

		board.chosen_elements = []
		get_parent().get_parent().update_energy(1)
		queue_free()
	else:
		self.reparent(board.get_node("Buffer"))
		board.rebalance()
		if value == 2:
			board.add_element("dice",false,1)
			board.add_element("dice",false,1)
		else:
			board.add_element("dice",false,2)
			board.add_element("dice",false,1)
		get_parent().get_parent().update_energy(1)
		queue_free()

func merge(element):
	if element is Card:
		reparent(get_parent().get_parent().get_node("Buffer"))
		element.reparent(get_parent().get_parent().get_node("Buffer"))
		get_parent().get_parent().rebalance()
		if int((value + element.value))%14 >= 2:
			get_parent().get_parent().add_element("card",false,int(value + element.value)%14)
		else:
			get_parent().get_parent().add_element("card",false,14)
			
		element.queue_free()
		get_parent().get_parent().update_energy(1)
		queue_free()
		

func mergeable(element):
	if element is Card:
		return true
	return false

func count_result():
	var result = value
	for element in get_parent().get_parent().get_node("Elements").get_children():
		if element is not Card:
			result += 2
	return result
