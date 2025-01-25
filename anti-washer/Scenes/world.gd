extends Node3D

@onready var paintingScene = $PaintingScene
@onready var menu
var possibleNames = [
  "Ethan B. Harrington",
  "Isla M. Donovan",
  "Lucas T. Caldwell",
  "Sophia K. Montgomery",
  "Oliver C. Whitaker",
  "Lily J. Pembroke",
  "Mason R. Carter",
  "Amelia P. Sterling",
  "William D. Fitzgerald",
  "Chloe S. Hawthorne",
  "Jameson T. Blake",
  "Zara L. Kensington",
  "Benjamin A. Thornton",
  "Elena R. Wakefield",
  "Caden F. Ashford",
  "Maya V. Sutherland",
  "Julian W. Everett",
  "Grace E. Carrington",
  "Dexter H. Wellington",
  "Victoria N. Harrison"
]

func _ready() -> void:
	show_menu()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"): ##escape pressed
		show_menu()

func show_menu():
	return
	menu.visible = !menu.visible #show/hide menu
	if menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.mouse_filter
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called when the node enters the scene tree for the first time.
func new_painting():
	var n
	if possibleNames.is_empty():
		n = "NoName"
	else:
		n = possibleNames.pop_at(randi() % (possibleNames.size()-1)) ## pops a name from the list at a random point in the list
	var dict = {"name": n}
	paintingScene.setup(dict)
