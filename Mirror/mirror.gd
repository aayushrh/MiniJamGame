extends StaticBody2D

var start = Vector2.ZERO
var end = Vector2.ZERO
var type = "Regular"

var selected = false

func _unhandled_input(event):
	if(selected and event is InputEventScreenTouch and event.pressed):
		selected = false

func initialize():
	$CollisionShape2D.shape.a = start
	$CollisionShape2D.shape.b = end
	queue_redraw()

func _process(delta):
	queue_redraw()

func _draw():
	if !selected:
		if(type == "reg"):
			_draw_line(start, end, Color("#FD3754"), 5)
		if(type == "dupe"):
			_draw_line(start, end, Color("#A946FA"), 5)
		if(type == "mult"):
			_draw_line(start, end, Color("#49a5c1"), 5)
		if(type == "null"):
			_draw_line(start, end, Color("#feca3a"), 5)
	else:
		_draw_line2(start, end, Color("#0000FF", 0.3), 15)

func _draw_line(start, end, color, width):
	$Line2D.visible = true
	$Line2D.points = [start, end]
	$Line2D.default_color = color 
	$Line2D.width = width

func _draw_line2(start, end, color, width):
	$Line2D2.visible = true
	$Line2D2.points = [start, end]
	$Line2D2.default_color = color 
	$Line2D2.width = width
