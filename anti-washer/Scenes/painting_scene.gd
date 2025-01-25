extends StaticBody3D

@onready var mySprite = $Sprite3D
@onready var myCollider = $CollisionShape3D
@onready var myPlaque = $MeshInstance3D

var myOwner = "":
	set(mo):
		myOwner = mo
		if myPlaque != null:
			var new_text = TextMesh.new()
			new_text.text = mo
			myPlaque.mesh=new_text

func setup(newDict) -> void:
	for key in newDict.keys():
		match key:
			"name": myOwner = newDict[key]

func _ready() -> void:
	## set the collider
	var spriteRect = mySprite.get_item_rect()
	var shape = BoxShape3D.new() ## make a new shape for the painting
	spriteRect.size *= mySprite.pixel_size ## multiplies the shape size by the pixel density
	shape.size = Vector3(spriteRect.size.x, spriteRect.size.y, 1) ## sets the shape to be the same size as the painting
	print(shape)
	print(spriteRect)
	myCollider.shape = shape ##sets the collider shape to be the new shape
	## set the owner of the painting
