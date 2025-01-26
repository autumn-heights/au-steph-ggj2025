extends Node3D

const RAY_LENGTH = 100
@onready var hitMarker = $Aimer
@onready var sponge = preload("res://Scenes/sponge.tscn")
@onready var playerHands = $Hand
@onready var sponge_mesh = $Hand/SpongeMesh
@onready var animHandler = $AnimationPlayer

@export var can_throw = true

var lastHit
var tween : Tween
@export var state: STATES = STATES.Idle
enum STATES {Idle, Aiming}
var raise_time = 0.3
var lower_time = 0.3
var topHPos = Vector3(-0.8, -0.6, 0)
var botHPos = Vector3(-0.8, -1.2, 0)
var cooldownTimer = 0.0
const COOLDOWN = 0.4
signal thrown_sponge
var sponges = 0

func _ready() -> void:
	cooldownTimer = COOLDOWN
	animHandler.play("Ready")

func _process(delta: float) -> void:
	if !can_throw:
		if cooldownTimer < COOLDOWN:
			cooldownTimer += delta
		elif !animHandler.is_playing():
			animHandler.play("Reload")
	if !animHandler.is_playing():
		if Input.is_action_just_pressed("aimhands") && state == STATES.Idle:
			animHandler.play("Ready", -1, 1.2)
		elif Input.is_action_just_released("aimhands") && state == STATES.Aiming:
			animHandler.play_backwards("Ready")
func _physics_process(delta: float) -> void:
	var hit = raycast()
	if !hit.is_empty():
		hitMarker.visible = true
		hitMarker.position = hit.position
		hitMarker.position.z += 0.06
		lastHit = hit
	else:
		hitMarker.visible = false

func throw_sponge():
	sponges -= 1
	var new = sponge.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	new.add_to_group("Sponge")
	new.position = global_position
	new.position = sponge_mesh.global_position
	new.rotation = sponge_mesh.global_rotation
	get_tree().get_root().add_child(new)
	new.start = sponge_mesh.global_position
	new.end = lastHit.position
	can_throw = false
	cooldownTimer = 0.0
	emit_signal("thrown_sponge")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throw") && sponges > 0:
		if !can_throw || state == STATES.Idle: return
		animHandler.play("Fire", -1, 2.0)
	#elif event.is_action("aimhands") && !animHandler.is_playing():
		#if event.is_action_pressed("aimhands"):
			#animHandler.play("Ready")
		#elif event.is_action_released("aimhands"):
			#animHandler.play_backwards("Ready")

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
