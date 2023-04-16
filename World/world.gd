extends Node2D

var buildRot = Vector2(0, 1)
var rotations = [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1),
Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1)]
var mirrorsPosPlaced = []
var mirrorsPlaced = []
var can_spawn = true
var spawning = false
var left = 0
var selected = []
var dragging = false
var drag_start = Vector2.ZERO


@onready var Mirror = preload("res://Mirror/mirror.tscn")
@onready var Enemy = preload("res://Enemies/enemy.tscn")
@onready var Bullet = preload("res://World/bullet.tscn")

func _unhandled_input(event):
	queue_redraw()
	if Global.mode == "Select" and Input.is_action_pressed("selection"):
		if selected.size() != 0:
			Global.selecting = true
		if event is InputEventScreenTouch:
			if event.pressed:
				if selected.size() == 0:
					dragging = true
					drag_start = get_global_mouse_position()
				else:
					selected.clear()
			elif dragging:
				dragging = false
				queue_redraw()
				var drag_end = get_global_mouse_position()
				selected = check(drag_start, drag_end)
				for item in selected:
					item.collider.selected = true
		if event is InputEventScreenDrag and dragging:
			queue_redraw()

func _ready():
	$Timer.start(1)
	_spawnWave(20)

func _process(delta):
	if($Line2D.visible):
		$Line2D.visible = false
	if spawning:
		if can_spawn:
			$Timer2.start(1)
			_spawn()
			can_spawn = false
			left -= 1 
			if(left <= 0):
				spawning = false
	if(Global.mode == "Build"):
		if(Input.is_action_just_pressed("rotate")):
			var index = rotations.find(buildRot)
			index = fmod(index + 1, rotations.size())
			buildRot = rotations[index]
			
		if(Input.is_action_just_pressed("place")):
			var nothing = true
			var pos = get_pos()
			for v in mirrorsPosPlaced:
				if(pos.distance_to(v) <= 60):
					nothing = false
			if nothing:
				var mirror = Mirror.instantiate()
				mirror.start = get_start(pos)
				mirror.end = get_end(pos)
				get_tree().current_scene.add_child(mirror)
				mirror.type = Global.placing
				mirror.initialize()
				mirrorsPosPlaced.append(pos)
				mirrorsPlaced.append(mirror)
				Global.mode = "Select"
		
	if(Input.is_action_just_pressed("destroy")):
		var pos = get_pos()
		for i in range(mirrorsPosPlaced.size()):
			if(pos.distance_to(mirrorsPosPlaced[i]) <= 60):
				mirrorsPlaced[i].queue_free()
				mirrorsPlaced.remove_at(i)
				mirrorsPosPlaced.remove_at(i)
				break
	queue_redraw()

func check(start, end):
	var select_rect = RectangleShape2D.new()
	select_rect.extents = (end - start)/2
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(select_rect)
	query.transform = Transform2D(0, (end + start)/2)
	var selected = []
	selected = space.intersect_shape(query)
	var new_selected = []
	for i in range(0, selected.size()):
		new_selected.append(selected[i])
	selected = new_selected
	return selected

func _draw():
	if dragging:
		if Global.mode == "Select" and Input.is_action_pressed("selection"):
			draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(0, 0, 0.5), false)
	if Global.mode == "Build":
		var pos = get_pos()
		var start = get_start(pos)
		var end = get_end(pos)
		var color = null
		if(Global.placing == "reg"):
			_draw_line(start, end, Color("#FD3754", 0.5), 5)
		elif(Global.placing == "dupe"):
			_draw_line(start, end, Color("#A946FA", 0.5), 5)
		elif(Global.placing == "mult"):
			_draw_line(start, end, Color("#49a5c1", 0.5), 5)
		elif(Global.placing == "null"):
			_draw_line(start, end, Color("#feca3a", 0.5), 5)

func _draw_line(start, end, color, width):
	$Line2D.visible = true
	$Line2D.points = [start, end]
	print(color)
	$Line2D.default_color = color 
	$Line2D.width = width

func get_pos():
	var pos = get_global_mouse_position() + Vector2(16, 16)
	pos = Vector2(pos.x - fmod(pos.x, 32), pos.y - fmod(pos.y, 32))
	return pos

func get_start(pos):
	var start = pos + buildRot.normalized() * 16
	return start

func get_end(pos):
	var end = pos - buildRot.normalized() * 16
	return end

func _spawn():
	var enemy = Enemy.instantiate()
	enemy.global_position = $Node2D/Marker2D.global_position
	enemy.list = $Node2D
	get_tree().current_scene.add_child(enemy)

func _spawnWave(num):
	spawning = true
	left = num

func _add_bullet():
	var bullet = Bullet.instantiate()
	if($CanvasLayer/UI/Node2D.get_child_count() > 0):
		var prevBullet = $CanvasLayer/UI/Node2D.get_child($CanvasLayer/UI/Node2D.get_child_count() - 1)
		bullet.position = prevBullet.position + Vector2(25, 0)
	else:
		bullet.position = Vector2(25, 25)
	$CanvasLayer/UI/Node2D.add_child(bullet)

func _delete_bullet():
	var e = $CanvasLayer/UI/Node2D.get_child($CanvasLayer/UI/Node2D.get_child_count() - 1)
	e.queue_free()

func _on_timer_2_timeout():
	can_spawn = true
