extends Control


const GAME_SCENE_PATH = "res://Scenes/GameScene.tscn"
@onready var creditsWindow = $CanvasLayer/GameMenu/Window


func OnPlayButtonPressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func OnCreditsButtonPressed() -> void:
	creditsWindow.show()


func OnExitButtonPressed() -> void:
	get_tree().quit(0)


func OnWindowCloseRequested() -> void:
	creditsWindow.hide()
