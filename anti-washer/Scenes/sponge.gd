extends CharacterBody3D

var throwHeight = 0.5
var start = Vector3.ZERO
var end = Vector3(1, 0, -1)
var p = 0.0 ## progress
var ttt = 1.0 #time to target
var grav = -9.8
var spinSpeed = 0.3
var minSpin = 0.5
var maxSpin = 5.0
var can_hit = true

func _ready() -> void:
	rotation.y = PI/2
	var x = randf()
	rotation.y += randf_range(-PI/4, PI/4)
	rotation.x += lerp(-PI/4, PI/4, x)
	spinSpeed = lerp(minSpin, maxSpin, x)
	rotation.z += randf_range(-PI/4, PI/4)
var tween : Tween

func _physics_process(delta: float) -> void:
	if p < ttt:
		p += delta
		var r = p/ttt
		print(sin(PI * r))
		var h = sin(PI * r) * throwHeight
		var des = start.lerp(end, r)
		des.y += h
		#velocity = des - position
		position = des
		rotate_x(-delta * spinSpeed)
	elif !is_on_floor():
		velocity.y += delta * grav
	else: velocity.y = 0
	if move_and_slide():
		hit_something(get_last_slide_collision())

func hit_something(thing : KinematicCollision3D):
	for i in thing.get_collision_count():
		var hit = thing.get_collider(i)
		print(hit)
		if hit.is_in_group("Painting") && can_hit:
			add_collision_exception_with(hit)
			can_hit = false
			if tween:
				tween.kill
			tween = get_tree().create_tween()
			var r = rotation
			r.y = PI/2
			tween.tween_property(self, "rotation", r, 0.2)
			tween.tween_callback(tween.kill)
