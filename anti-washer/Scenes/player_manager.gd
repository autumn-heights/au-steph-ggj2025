extends Node3D

const RAY_LENGTH = 100
@onready var hitMarker = $MeshInstance3D
func _physics_process(delta: float) -> void:
	var hit = raycast()
	hitMarker.visible = !hit.is_empty()
	if hitMarker.visible:
		hitMarker.position = hit.position
	

func raycast():
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	#query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result
