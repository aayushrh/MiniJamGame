extends CharacterBody2D

@export var ACCELERATION := 500
@export var MAX_SPEED := 200
@export var FRICTION := 0.9

var list = null
var index = 0

func _ready():
	$AnimatedSprite2D.play("Run")

func _process(delta):
	if(list.get_child(index).global_position.distance_to(global_position) <= 16):
		index = (index + 1) % list.get_child_count()
	var input_vector = list.get_child(index).global_position - global_position
	input_vector = input_vector.normalized()
	if(input_vector != Vector2.ZERO):
		velocity += input_vector * ACCELERATION
	velocity *= FRICTION
	move_and_slide()

func _on_hurtbox_area_entered(area):
	queue_free()
