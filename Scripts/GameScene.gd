extends Node2D


var isPause = false
@onready var pauseMenu = $CanvasLayer/PauseMenu
const START_SCENE_PATH = "res://Scenes/StartScene.tscn"


func _ready() -> void:
	pauseMenu.hide()
	Engine.time_scale = 1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PauseAction"):
		OnPause()


func OnPause() -> void:
	if !isPause:
		isPause = true
		pauseMenu.show()
		Engine.time_scale = 0
	else:
		isPause = false
		pauseMenu.hide()
		Engine.time_scale = 1


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(START_SCENE_PATH)


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)


func _on_resume_button_pressed() -> void:
	OnPause()
