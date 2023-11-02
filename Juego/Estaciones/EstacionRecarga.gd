class_name EstacionRecarga

extends Node2D

export var energia: float = 4.0
export var radio_energia_entregada: float = 0.1

var nave_player: Player = null
var player_en_zona:bool = false

#var on_sonidos_car: bool = false
#var on_sonidos_vac: bool = false
onready var carga_sfx:AudioStreamPlayer = $CargaSfx
onready var vacio_sfx:AudioStreamPlayer2D = $VacioSfx

func _unhandled_input(event: InputEvent) -> void:
	
	if not puede_recargar(event):
		on_sonido_vacio(event)
		return
	controlar_energia()
	if event.is_action("recarga_escudo"): 
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("recarga_laser"): 
		nave_player.get_laser().controlar_energia(radio_energia_entregada)
## Metodos Custom 
func puede_recargar(event: InputEvent) -> bool: 
	var hay_input = event.is_action("recarga_escudo") or event.is_action("recarga_laser")
	if hay_input and player_en_zona and energia > 0.0: 
		if !carga_sfx.playing: 
			carga_sfx.play()
		else:
			carga_sfx.stop()
		return true
	return false


func controlar_energia() -> void:
	energia -= radio_energia_entregada
	if energia <= 0.0 : 
		vacio_sfx.play()
#		on_sonidos_vac= true
#Solo Debug, QUITAR 
	print("Energia Estacion: ", energia)
	
	
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		nave_player = body
		player_en_zona = true
		
	body.set_gravity_scale(0.5)


func _on_AreaRecarga_body_exited(body: Node) -> void:
	player_en_zona = false
	vacio_sfx.stop()
	carga_sfx.stop()
	body.set_gravity_scale(0.0)
	
func on_sonido_vacio(event: InputEvent) ->void:
	var pres_tecla = event.is_action("recarga_escudo") or event.is_action("recarga_laser")
	if pres_tecla and !vacio_sfx.playing:
		vacio_sfx.play()
	
	
	
	
