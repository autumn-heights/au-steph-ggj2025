extends CharacterBody3D

@onready var mySprite = $Sprite3D
@onready var myCollider = $HitArea/CollisionShape3D
signal new_destination
var destination
var tween : Tween
var sprite_path = "res://Assets/Textures/Walking People/"
var characteristic_list = [
	{
		"filename":"400px-pedestrian-1",
		"shapeBounds":Vector3(0.731, 1.9, 0.5),
		"shapePos":Vector3(0.05, 0, 0),
	},
	{
		"filename":"400px-pedestrian-2",
		"shapeBounds":Vector3(0.666, 1.9, 0.5),
		"shapePos":Vector3(-0.019, 0, 0),
	},
	{
		"filename":"400px-pedestrian-3",
		"shapeBounds":Vector3(0.742, 1.9, 0.5),
		"shapePos":Vector3(-0.016, 0, 0),
	},
	{
		"filename":"400px-pedestrian-4",
		"shapeBounds":Vector3(0.762, 1.9, 0.5),
		"shapePos":Vector3(0.047, 0, 0),
	},
	{
		"filename":"400px-pedestrian-5",
		"shapeBounds":Vector3(1.532, 1.9, 0.5),
		"shapePos":Vector3(0, 0, 0),
	},
	{
		"filename":"400px-pedestrian-6",
		"shapeBounds":Vector3(0.686, 1.9, 0.5),
		"shapePos":Vector3(0.049, 0, 0),
	},]

var bikemanChance = 0.05
var bikemanDict = {
		"filename":"400px-pedestrian-7",
		"shapeBounds":Vector3(0.951, 1.9, 0.5),
		"shapePos":Vector3(-0.054, 0, 0),
		"ms": 2
	}

var rotationVar = 0.3
var move_speed = 2

func _ready() -> void:
	var nDict
	if randf() < bikemanChance:
		print("im bikeman!")
		nDict = bikemanDict
	else:
		nDict = characteristic_list[randi() % (characteristic_list.size() - 1)]
	for key in nDict.keys():
		match key:
			"filename": mySprite.texture = load(sprite_path + nDict[key]+".png")
			"shapeBounds": myCollider.shape.size = nDict[key]
			"shapePos": myCollider.position = nDict[key]
			"ms": move_speed = nDict[key]
	move_speed *= 1 + randf_range(-0.1, 0.1)
	print("walker move speed ", move_speed)
var approach_dist = 2.0
var approach_speed = 0.2

func _physics_process(delta: float) -> void:
	if destination == null:
		emit_signal("new_destination")##get a new spot to go to
		return
	var dist = position.distance_to(destination)
	var c_speed = move_speed
	velocity = position.direction_to(destination)
	if dist<= 0.3:
		#print("my destination has been reached")
		destination = null
		emit_signal("new_destination")
	elif dist < approach_dist:
		c_speed = lerp(approach_speed, move_speed, dist/approach_dist)
	velocity *= c_speed ##set velocity to the direction to this destination
	move_and_slide()
