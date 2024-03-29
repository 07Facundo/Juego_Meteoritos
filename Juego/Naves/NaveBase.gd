class_name NaveBase

extends RigidBody2D

enum ESTADO{SPAWN, VIVO, INVENCIBLE, MUERTO}

export var hitpoints: float = 20.0
export var explosiones_naves:int
var estado_actual: int = ESTADO.SPAWN

onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var impacto_sfx: AudioStreamPlayer = $ImpactoSfx
onready var canion:Canion = $Canion
onready var barra_salud: BarraSalud = $BarraSalud
onready var timer_offImpacto_sfx: Timer = $TimerOffImpacto


## Metodos
func _ready() -> void:
	barra_salud.set_valores(hitpoints)
	controlar_estados(estado_actual)


func controlar_estados(new_status) -> void:
	match new_status:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled",false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
				colisionador.set_deferred("disabled", true)
				canion.set_puede_disparar(true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position, explosiones_naves)
			queue_free()
		_:
			printerr("Error de estado")
	estado_actual = new_status
	


func destruir() -> void:
	controlar_estados(ESTADO.MUERTO)
	
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	timer_offImpacto_sfx.start()
	barra_salud.controlar_barra(hitpoints, true)
	impacto_sfx.play()
	
func _on_Timer_timeout() -> void:
	impacto_sfx.stop()


func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()


func _on_TimerOffImpacto_timeout() -> void:
	impacto_sfx.stop()
