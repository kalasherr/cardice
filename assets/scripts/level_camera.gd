extends Camera2D
@onready var button_container = $CanvasLayer/MidB/HBoxContainer
@onready var progress_bar = $CanvasLayer/MidR/ProgressBar
@onready var energy_bar = $CanvasLayer/MidB/ProgressBar
@onready var new_element = $CanvasLayer/MidB/NewElement
func _ready():
	pass

func _process(delta):
	confirm_button()

func retranslate(button):
	get_parent().press_button(button)

func _on_saw_pressed():
	retranslate("saw")

func confirm_button():
	if get_parent().pressed_button == null or get_parent().chosen_elements == []:
		get_node("CanvasLayer/MidB/Confirm").visible = false
	else:
		get_node("CanvasLayer/MidB/Confirm").visible = true


func _on_confirm_pressed():
	retranslate("confirm")


func _on_merge_pressed():
	retranslate("merge")


func _on_morph_pressed():
	retranslate("morph")


func _on_new_pressed():
	retranslate("add")


func _on_new_element_pressed():
	retranslate("end")
