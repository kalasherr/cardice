extends Camera2D

func _ready():
	pass

func _process(delta):
	pass

func retranslate(button):
	get_parent().press_button(button)

func _on_saw_pressed():
	retranslate("saw")
	
