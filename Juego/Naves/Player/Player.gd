class_name Player

extends NaveBase


export var potencia_motor: int = 18
export var potencia_rotacion: int = 260
export var estela_maxima: int = 150


var empuje: Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var esta_en_sector:bool = true setget set_esta_en_sector

onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var estela: Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx: Motor = $MotorSFX
onready var escudo: Escudo = $Escudo setget, get_escudo


##Setters y Getters
func get_laser() -> RayoLaser:
	return laser

func get_escudo() -> Escudo:
	return escudo
func set_esta_en_sector(valor:bool) ->void:
	esta_en_sector = valor
	
##Metodos

func _ready() -> void:
	DatosJuego.set_player_actual(self)

func _unhandled_input(event: InputEvent) -> void:
	if not input_is_activo():
		return
	#Disparo Rayo
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)	
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
		
	#Estela y sonido del motor
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
	if event.is_action_released("mover_adelante") or event.is_action_released("mover_atras"):
		motor_sfx.sonido_off()
	#Escudo
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()	
	elif event.is_action_pressed("escudo") and escudo.get_esta_activado():
		escudo.desactivar()
		Eventos.emit_signal("ocultar_energia_escudo")


func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)


func _process(_delta: float) -> void:
	player_input()

##Metodos Custom
func player_input() -> void:
	if not input_is_activo():
		return


#	Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje= Vector2(potencia_motor, 0)
		motor_sfx.sonido_on()
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
		motor_sfx.sonido_on()
#	Rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1 
#	Disparo
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
		

func input_is_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	return true

func desactivar_controles () -> void:
	controlar_estados(ESTADO.SPAWN)
	empuje = Vector2.ZERO
	motor_sfx.sonido_off()
	laser.set_is_casting(false)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)
