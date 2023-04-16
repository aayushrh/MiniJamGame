extends Control


func _on_regular_pressed():
	print("e")
	Global.mode = "Build"
	Global.placing = "reg"

func _on_duplicator_pressed():
	Global.mode = "Build"
	Global.placing = "dupe"

func _on_multiplicator_pressed():
	Global.mode = "Build"
	Global.placing = "mult"

func _on_nullificator_pressed():
	Global.mode = "Build"
	Global.placing = "null"
