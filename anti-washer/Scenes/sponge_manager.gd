extends PanelContainer

var max_sponges = 10
var current_sponges
@onready var spongeHolder = $VBoxContainer/HBoxContainer
@onready var spongeCountLabel = $VBoxContainer/Label
var spongeTexPath
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
		

func get_new_sRect():
	var r = TextureRect.new()
	r.texture = load(spongeTex)
	r.custom_minimum_size = Vector2(48,48)
	return r

func update_sponges(a):
	current_sponges += a
	current_sponges = clamp(current_sponges, 0, max_sponges)
	spongeCountLabel.text = var_to_str(current_sponges) + " / " + var_to_str(max_sponges)
	for i in max_sponges:
		var rect = spongeHolder.get_child(i)
		if i > spongeHolder.get_child_count():
			spongeHolder.add_child(get_new_sRect())
		if i > current_sponges:
			rect.modulate = Color(0.1, 0.1, 0.1, 1)
		else:
			rect.modulate = Color.WHITE
