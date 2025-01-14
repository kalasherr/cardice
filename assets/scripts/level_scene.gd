extends Node2D

func _ready():
	add_child(load("res://assets/scenes/elements/dice.tscn").instantiate())

func _process(delta):
	pass
