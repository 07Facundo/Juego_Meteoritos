class_name Motor

extends AudioStreamPlayer2D

export var tiempo_transicion: float = 0.6
export var volumen_apagado: float = -15.0

onready var tween_sonido: Tween= $Tween

var volumen_original: float

func _ready() -> void:
	volumen_original = volume_db 
	volume_db = volumen_apagado

func sonido_on() -> void: 
	#Check si no esta sonando y ejecutar el efecto
	#de transicion
	if not playing:
		play()
	
	efecto_transicion(volume_db, volumen_original)
	

func sonido_off() -> void:
	#Ejecutar el efecto de transicion
	efecto_transicion(volume_db, volumen_apagado)

func efecto_transicion (desde_vol: float, hasta_vol: float) -> void: 
	tween_sonido.interpolate_property(
		self,
		"volume_db",
		desde_vol,
		hasta_vol,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	) 
	tween_sonido.start()
