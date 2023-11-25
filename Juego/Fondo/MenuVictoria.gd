extends Node

func _ready() -> void:
	MusicaJuego.onof_musicas_princ(true)
	MusicaJuego.play_musica(MusicaJuego.musica_menu_victoria)


func _on_ButtonVolverMenu_pressed() -> void:
	MusicaJuego.musica_menu_victoria.stream_paused = true
	get_tree().change_scene("res://Juego/Fondo/MenuPrincipal.tscn")


func _on_ButtonSalir_pressed() -> void:
	get_tree().quit()
