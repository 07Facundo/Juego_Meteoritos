extends Node
## Atributos Export
export var tiempo_transicion: float = 4.0
export(float, -50.0, -20.0, 5.0) var volumen_apagado = -40.0

## Atributos
var vol_original_musica_off:float = 0.0

## Atributos Onready
onready var musica_nivel:AudioStreamPlayer = $MusicaNivel
onready var musica_combate:AudioStreamPlayer = $MusicaCombate 
onready var tween_on: Tween = $TweenMusicaOn
onready var tween_off: Tween = $TweenMusicaOff
onready var lista_musicas: Dictionary ={ "menu_principal": $MusicaMenuPrincipal } setget, get_lista_musicas
onready var musica_menu_principal: AudioStreamPlayer = $MusicaMenuPrincipal
onready var musica_menu_victoria: AudioStreamPlayer = $MusicaMenuVictoria
onready var boton_menu: AudioStreamPlayer = $BotonMenu

func get_lista_musicas() -> Dictionary:
	return lista_musicas


## Metodos Custom
func play_boton() ->void:
	boton_menu.play()


func play_musica(musica: AudioStreamPlayer) -> void: 
	stop_todo ()
	musica.play()


func set_streams(stream_musica: AudioStream, stream_combate: AudioStream) -> void:
	musica_nivel.stream = stream_musica
	musica_combate.stream = stream_combate


func play_musica_nivel()-> void:
	stop_todo()
	musica_nivel.volume_db = -15
	musica_nivel.play()
	

func stop_todo() -> void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer: 
			nodo.stop()

func onof_musicas_princ(valor: bool) ->void:
	musica_nivel.stream_paused = valor
	musica_combate.stream_paused = valor

func transicion_musicas() -> void:
	if musica_nivel.playing:
		fade_in(musica_combate)
		fade_out(musica_nivel)
	else:
		fade_in(musica_nivel) 
		fade_out(musica_combate)
		

func fade_in(musica_fade_in: AudioStreamPlayer) -> void:
	musica_fade_in.volume_db = -15
	var volumen_original = musica_fade_in.volume_db 
	musica_fade_in.volume_db = volumen_apagado
	musica_fade_in.play() 
	tween_on.interpolate_property(
		musica_fade_in, 
		"volume_db", 
		volumen_apagado, 
		volumen_original, 
		tiempo_transicion, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	tween_on.start()


func fade_out(musica_fade_out: AudioStreamPlayer) -> void:
	musica_fade_out.volume_db = -15
	vol_original_musica_off = musica_fade_out.volume_db
	tween_off.interpolate_property(
		musica_fade_out,
		"volume_db",
		musica_fade_out.volume_db,
		volumen_apagado,
		tiempo_transicion, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	tween_off.start()


## Señales Internas
func _on_TweenMusicaOff_tween_completed (object: Object, _key: NodePath) -> void:
	object.stop()
	object.volume_db = vol_original_musica_off



func _on_MusicaNivel_finished() -> void:
	if not musica_combate.is_playing():
		play_musica_nivel()


func _on_MusicaCombate_finished() -> void:
	if not musica_nivel.is_playing():
		musica_combate.play()



func _on_MusicaMenuPrincipal_finished() -> void:
	musica_menu_principal.play()

func destruir_musica(musica: AudioStreamPlayer) ->void:
	musica.queue_free()


func _on_MusicaMenuVictoria_finished() -> void:
	musica_menu_victoria.play()
