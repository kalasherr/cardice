extends Node2D

var pressed_button = null
var chosen_elements = []


func _ready():
	var dice = load("res://assets/scenes/elements/dice.tscn").instantiate()
	add_child(dice)
	dice.move(Vector2(100,0))
	dice = load("res://assets/scenes/elements/dice.tscn").instantiate()
	add_child(dice)
	dice.move(Vector2(100,100))
	dice = load("res://assets/scenes/elements/dice.tscn").instantiate()
	add_child(dice)
	dice.move(Vector2(0,100))

func _process(delta):
	pass

func press_button(button):
	chosen_elements = []
	pressed_button = null
	if button == "saw":
		pressed_button = "saw"
