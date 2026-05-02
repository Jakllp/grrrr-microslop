extends Area2D

@export var shape :Shape2D

func _ready() -> void:
	$CollisionShape2D.shape = shape
