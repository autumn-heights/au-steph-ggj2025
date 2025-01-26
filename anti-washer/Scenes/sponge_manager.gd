extends PanelContainer

var max_sponges = 10
var current_sponges
@onready var spongeHolder = $VBoxContainer/HBoxContainer
@onready var spongeCountLabel = $VBoxContainer/Label
@onready var myGameOverMessage = $GameOverMessage
var spongeTexPath = "res://Assets/Textures/Sponge-pixart.png"
var spongeTex: 
	get():
		if spongeTexPath == null:
			return "res://icon.svg"
		else:
			return spongeTexPath

func _ready() -> void:
	if current_sponges == null || current_sponges != max_sponges:
		current_sponges = max_sponges
	for i in spongeHolder.get_child_count():
		spongeHolder.get_child(i).queue_free()
	for i in max_sponges:
		spongeHolder.add_child(get_new_sRect())
	update_sponges(0)
	
	myGameOverMessage.hide()

func get_new_sRect():
	var r = TextureRect.new()
	r.texture = load(spongeTex)
	r.custom_minimum_size = Vector2(48, 48)
	r.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	return r

func update_sponges(a):
	current_sponges += a
	current_sponges = clamp(current_sponges, 0, max_sponges)
	spongeCountLabel.text = var_to_str(current_sponges) + " / " + var_to_str(max_sponges)
	for i in max_sponges:
		var rect = spongeHolder.get_child(i)
		if i >= current_sponges:
			rect.modulate = Color(0.1, 0.1, 0.1, 1)
		else:
			rect.modulate = Color.WHITE
			
	if current_sponges == 0:
		show_final_message()


func show_final_message():
	
	var new_text = ""
	new_text += "Thank you for playing \n this cool game by au and steph \n"
	new_text += "Made for Perth Global Game Jam 2025 \n"
	new_text += "Please see proj description \n for stock photo credits"
	myGameOverMessage.mesh.text = new_text
	myGameOverMessage.position = Vector3(-1,0,0)
	
	myGameOverMessage.show()
	
