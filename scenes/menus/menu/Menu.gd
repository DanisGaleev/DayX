
extends Control

export var game_path = "res://scenes/game/game/game.tscn"

func _on_Start_pressed():
	get_tree().change_scene(game_path)
