extends Node3D

const RAY_LENGTH = 100
@onready var hitMarker = $Aimer
@onready var sponge = preload("res://Scenes/sponge.tscn")
@onready var playerHands = $AnimatedSprite3D
var lastHit
var tween : Tween
var state: STATES = STATES.Idle
enum STATES {Idle, Aiming}
var raise_time = 0.3
var lower_time = 0.3
var topHPos = Vector3(-0.814, -0.631, 0)
var botHPos = Vector3(-0.814, -1.2, 0.042)

func _physics_process(delta: float) -> void:
	var hit = raycast()
	if !hit.is_empty():
		hitMarker.visible = true
		hitMarker.position = hit.position
		lastHit = hit
	else:
		hitMarker.visible = false

var can_throw = true

func throw_sponge(start, end):
	var new = sponge.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	new.position = global_position
	get_tree().get_root().add_child(new)
	new.start = global_position
	new.end = end

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		if !can_throw || state == STATES.Idle: return
		throw_sponge(get_viewport().get_mouse_position(), lastHit.position)
	elif event.is_action("aimhands"):
		if event.is_action_pressed("aimhands"):
			animate_hands(true)
		elif event.is_action_released("aimhands"):
			animate_hands(false)

func animate_hands(raising):
	if playerHands == null:
		printerr("playerHands not found... skipping animatin")
	if tween: tween.kill()
	tween = get_tree().create_tween()
	var npos = topHPos
	var nt = raise_time
	var ns = STATES.Aiming
	if !raising:
		npos = botHPos
		nt = lower_time
		ns = STATES.Idle
	tween.tween_property(playerHands, "position", npos, nt)
	tween.tween_property(self, "state", ns, 0.0)
	tween.tween_callback(tween.kill)

func raycast():
	var space_state = get_world_3d().direct_space_state
	var vp = get_viewport()
	var cam = vp.get_camera_3d()
	var mousepos = vp.get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
	#query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result
