extends CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	$AnimatedSprite2D.rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI + 90
	#print($AnimatedSprite2D.rotation_degrees)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		scale *= 0.9
		if(scale.x < 0.1):
			queue_free()
		#velocity = velocity.bounce(collision_info.get_normal())
		var coll = collision_info.get_collider()
		if(coll.type == "dupe"):
			match(coll.level):
				1:
					pass
					#level1
		var h = abs(coll.end.y - coll.start.y)
		var w = abs(coll.end.x - coll.start.x)
		var speed = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
		if (w == 0):
			velocity.x *= -1
			velocity.y = 0
		elif (h == 0):
			velocity.y *= -1 
			velocity.x = 0
		else:
			var dir = 0 
			if((coll.end.y - coll.start.y)/(coll.end.x - coll.start.x) > 0):
				dir = -1 
			else:
				dir = 1
			if (velocity.x == 0):
				velocity.x = dir * speed
			else:
				velocity.x *= -1
			if (velocity.y ==0 ):
				velocity.y = speed
			else:
				velocity.y *= -1
			
