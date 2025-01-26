extends Node3D

var splatter_material_path = 'res://Assets/Meshes/cool-material.tres'
@export_file("*.glb") var splatter_mesh_path = 'res://Assets/Meshes/PaintSplatter1.glb'
@export var splatter_mesh_res = 'res://Assets/Meshes/PaintSplatter1_Mesh.res'
@export var max_splatters: int = 50

var splatters: Array[MeshInstance3D] = []

var SPLATTER_SCALE_FACTOR = 0.2

func _ready():
	# Preload the mesh scene
	get_tree().node_added.connect(_on_node_added)

func add_splatter(collision_point: Vector3, collision_normal: Vector3):
	if splatters.size() >= max_splatters:
		var oldest_splatter = splatters.pop_front()
		oldest_splatter.queue_free()
	
	
	
	var splatter = load(splatter_mesh_path).instantiate()
	var material = load(splatter_material_path)
	add_child(splatter)
	
	# Position at collision point
	splatter.global_position = collision_point
	
	# Random rotation around Y-axis
	splatter.rotation.y = randf_range(0, 2 * PI)
	
	# Random scale between 0.8x and 1.2x
	splatter.scale = SPLATTER_SCALE_FACTOR * Vector3(
			randf_range(0.8, 1.2), randf_range(0.8, 1.2), randf_range(0.8, 1.2))
	
	# Align to surface normal, facing away from surface
	splatter.look_at(collision_point - collision_normal)
	splatter.rotation.x = -PI/2
	
	# Randomly select a primary color
	if splatter is MeshInstance3D:
		print(splatter.mesh)
		material.albedo_color = generate_random_bright_color()
		splatter.material_override = material
		
	
	splatters.append(splatter)



func _on_node_added(node: Node):
	# Recursively check for sponges in all nodes
	_check_node_for_sponge(node)

func _check_node_for_sponge(node: Node):
	# Check current node
	if node.is_in_group("Sponge"):
		node.connect("create_a_splatter", _on_create_a_splatter)
	
	# Recursively check all children
	for child in node.get_children():
		_check_node_for_sponge(child)

func _on_create_a_splatter(collision_point, collision_normal):
	add_splatter(collision_point, collision_normal)


func generate_random_bright_color() -> Color:
	var min_val = 0.8
	var h = randf_range(0, 1.0)
	var s = randf_range(min_val, 1.0)
	var v = randf_range(min_val, 1.0)
	return Color.from_hsv(h, s, v)
