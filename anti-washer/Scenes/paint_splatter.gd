extends Node3D

@export_file("*.glb") var splatter_mesh_path = 'res://Assets/Meshes/PaintSplatter1.glb'
#@export var splatter_mesh_path = 'res://Assets/Meshes/PaintSplatter1_Mesh.res'
@export var max_splatters: int = 50

@export var splatter : MeshInstance3D 

var splatters: Array[MeshInstance3D] = []

var SPLATTER_SCALE_FACTOR = 0.2

var SPLATTER_POSSIBLE_COLORS = [
	Color(1, 0, 0), # Red
	Color(0, 1, 0), # Green
	Color(0, 0, 1)  # Blue
]

func _ready():
	# Preload the mesh scene
	get_tree().node_added.connect(_on_node_added)
	if splatter_mesh_path:
		splatter_mesh_path = load(splatter_mesh_path)

func add_splatter(collision_point: Vector3, collision_normal: Vector3):
	if splatters.size() >= max_splatters:
		var oldest_splatter = splatters.pop_front()
		oldest_splatter.queue_free()
	
	splatter = splatter_mesh_path.instantiate()
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
	var random_color = SPLATTER_POSSIBLE_COLORS[randi() % SPLATTER_POSSIBLE_COLORS.size()]
	#print(splatter)
	#print(splatter.get_surface_override_material())
	#if splatter is MeshInstance3D:
		#print(splatter.mesh)
		#var material = splatter.mesh.surface_get_material(0)
		#print(material)
		#if material:
			#material.albedo_color = random_color
	
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
