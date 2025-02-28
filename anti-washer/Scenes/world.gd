extends Node3D

@onready var paintingScene = $PaintingScene
@onready var menu = $CanvasLayer/Panel
@onready var mySplatters = $PaintSplatters
@onready var sponge_manager = $CanvasLayer/SpongeManager
@onready var player_manager = $PlayerManager
@onready var gameover_message = $CanvasLayer/GameOverMessage
@onready var walker_scene = preload("res://Scenes/walker.tscn")
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

var max_sponges = 10


var possiblePaintingParams = readJSON("res://Assets/art-notes.json")
var scene_size = Vector2(8,6)

func _ready() -> void:
	player_manager.thrown_sponge.connect(sponge_manager.update_sponges.bind(-1))
	player_manager.sponges = max_sponges
	sponge_manager.max_sponges = max_sponges
	sponge_manager.myGameOverMessage = gameover_message
	for walker in get_tree().get_nodes_in_group("Walker"):
		walker.new_destination.connect(get_destination.bind(walker)) ## connects the new_destination signal
		# from walker nodes in scene tree to the get_destination function
	show_menu()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	init_random_painting(paintingScene)

func create_walker():
	var new = walker_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	new.position = get_destination()
	new.destination = get_destination()
	get_tree().get_root().add_child(new)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"): ##escape pressed
		show_menu()

func show_menu():
	menu.visible = !menu.visible #show/hide menu
	if menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		menu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func get_destination(requester = null):
	#print("giving a destination to " + requester.to_string())
	var x = randf_range(-scene_size.x + 0.5, scene_size.x -0.5) *0.5
	var z = randf_range(-scene_size.y + 0.5, scene_size.y -0.5) *0.5
	var pos = Vector3(x, requester.position.y, z) ## setting the y to be the same as the requestor to prevent floating /sinking behaviour
	#print("new position for walker ", pos)
	if requester != null: requester.destination = pos
	else: return pos
	
# Called when the node enters the scene tree for the first time.
func init_random_painting(scene):
	var n
	if possibleNames.is_empty():
		n = "NoName"
	else:
		n = possibleNames.pop_at(randi() % (possibleNames.size()-1)) ## pops a name from the list at a random point in the list
	
	var dict = possiblePaintingParams.pop_at(randi() % (possiblePaintingParams.size()-1))
	print(dict)
	scene.setup(dict)

func readJSON(json_file_path):
	# stolen from reddit
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish
