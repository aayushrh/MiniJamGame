extends Node2D

@onready var Bullet = preload("res://bullet.tscn")

var bullets = 0

func _ready():
	Global.pPosition = global_position
	$ReloadTimer.start(10)

func _process(delta):
	if(Input.is_action_just_pressed("shoot") and bullets > 0 and !Input.is_action_pressed("selection") and get_global_mouse_position().y < 530):
		var vector = get_global_mouse_position() - global_position
		vector = vector.normalized()
		var bullet = Bullet.instantiate()
		bullet.global_position = global_position
		bullet.velocity = vector * 500
		get_tree().current_scene.add_child(bullet)
		bullets -= 1
		get_parent()._delete_bullet()

func _on_hurtbox_area_entered(area):
	print("hit")
	Global.health -= 1
	area.get_parent().queue_free()

func _on_reload_timer_timeout():
	bullets += 1
	$ReloadTimer.start(10)
	print("reload")
	get_parent()._add_bullet()
