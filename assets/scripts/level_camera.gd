extends Camera2D

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
