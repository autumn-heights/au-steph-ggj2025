extends StaticBody3D

@onready var mySprite = $Sprite3D
@onready var myCollider = $CollisionShape3D
@onready var myPlaque = $MeshInstance3D

var PAINTING_SCALE_FACTOR = 200.0

var paintingsFolder = "res://Assets/Textures/Paintings/"
var myArtist = "artist here"
var myYear = "year here"
var myTitle = "title here":
	set(val):
		myTitle = val
var myDescription = "desc here"
var myOwner = "owner here"
var myValue = 0

func _ready():
	set_tex()

func setup(newDict) -> void:
	print("setup called")
	
	for key in newDict.keys():
		match key:
			"filename": set_tex(paintingsFolder + newDict[key])
			"title": myTitle = newDict[key]
			"artist": myArtist = newDict[key]
			"year": myYear = newDict[key]
			"description": myDescription = newDict[key]
			"ownership": myOwner = newDict[key]
			"value": myValue = newDict[key]
	if myPlaque != null:
		if myPlaque.mesh is not TextMesh:
			var new_text_mesh = TextMesh.new()
			new_text_mesh.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			myPlaque.mesh=new_text_mesh
	var new_text = ""
	new_text += myArtist + "\n"
	new_text += myTitle + " " + myYear +"\n"
	new_text += myDescription
	myPlaque.mesh.text = new_text
	var width = myCollider.shape.size.x
	myPlaque.position.x = width/2

func set_tex(p = "res://icon.svg"):
	# load in the image
	# set the scale of the sprite based on the largest dimension of the image
	mySprite.texture = load(p)
	var widest_dimension = max(mySprite.texture.get_width(), mySprite.texture.get_height())
	mySprite.scale = Vector3(PAINTING_SCALE_FACTOR / widest_dimension, PAINTING_SCALE_FACTOR / widest_dimension, 1)
	
	## set the collider
	var spriteRect = mySprite.get_item_rect()
	
	var shape = BoxShape3D.new() ## make a new shape for the painting
	spriteRect.size *= mySprite.pixel_size ## multiplies the shape size by the pixel density
	spriteRect.size *= Vector2(mySprite.scale.x, mySprite.scale.y)
	shape.size = Vector3(spriteRect.size.x, spriteRect.size.y, 1) ## sets the shape to be the same size as the painting
	myCollider.shape = shape ##sets the collider shape to be the new shape
	myCollider.position.z = -shape.size.z/2
