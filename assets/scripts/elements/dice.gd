extends BaseElement

func _process(delta):
	pass

func variables_change():
	value_range = [1,6]
	sprite_path = "res://assets/sprites/elements/dice/core.png"

func init():
	sprite_node = get_node("Core/MainSprite")
	roll()
	print(value)
	var value_sprite = Sprite2D.new()
	value_sprite.texture = load("res://assets/sprites/elements/dice/" + str(value) + ".png")
	sprite_node.add_child(value_sprite)
