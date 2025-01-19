extends Sprite2D
var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_audio()
	var a = -700
	while a < get_viewport_rect().size.y:
		a += 2
		add_falling_card(a)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counter % 6 == 0:
		add_falling_card()
	for a in get_children():
		a.position.y += 2
		if a.position.y > 1000:
			a.queue_free()

func add_falling_card(y = -700):
	var x = randf_range(-get_viewport_rect().size.x/2,get_viewport_rect().size.x/2)
	var element = round(randf_range(0.51,3.49))
	var node = Sprite2D.new()
	node.position = Vector2(x,y)
	node.rotation = randf_range(-7,7)
	node.texture = load("res://assets/sprites/buttons/falling"+str(element)+".png")
	node.z_index += 1
	add_child(node)


func _on_button_pressed():
	get_tree().root.add_child(load("res://assets/scenes/level_scene.tscn").instantiate())
	get_parent().queue_free()

func add_audio():
	for a in get_tree().root.get_children():
		if a.name == "Audio":
			a.connect("finished",replay)
			return
	var aud = AudioStreamPlayer.new()
	aud.name = "Audio"
	aud.volume_db -= 10
	aud.stream = load("res://Lady Luck's Grin.wav")
	aud.autoplay = true
	get_tree().root.add_child.call_deferred(aud)
	aud.connect("finished",replay)
	aud.play()

func replay():
	for a in get_tree().root.get_children():
		if a.name == "Audio":
			a.play()
	
