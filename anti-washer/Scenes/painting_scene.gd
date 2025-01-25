extends StaticBody3D

@onready var mySprite = $Sprite3D
@onready var myCollider = $CollisionShape3D
@onready var myPlaque = $MeshInstance3D




var paintingsFolder = "res://Assets/Textures/Paintings/"
var myOwner = "":
	set(mo):
		myOwner = mo
		if myPlaque != null:
			var new_text = TextMesh.new()
			new_text.text = mo
			myPlaque.mesh=new_text
var myPainter
var myYear
var my

func setup(newDict) -> void:
	for key in newDict.keys():
		match key:
			"name": myOwner = newDict[key]
			"painter": myPainter = newDict[key]
			"path": set_tex(paintingsFolder + newDict[key])



func set_tex(p = "res://icon.svg"):
	mySprite.texture = load(p)
	## set the collider
	var spriteRect = mySprite.get_item_rect()
	var shape = BoxShape3D.new() ## make a new shape for the painting
	spriteRect.size *= mySprite.pixel_size ## multiplies the shape size by the pixel density
	shape.size = Vector3(spriteRect.size.x, spriteRect.size.y, 1) ## sets the shape to be the same size as the painting
	print(shape)
	print(spriteRect)
	myCollider.shape = shape ##sets the collider shape to be the new shape

func _ready() -> void:
	set_tex()
