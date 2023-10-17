class_name Escudo

extends Area2D

export var energia: float = 12.0
export var radio_desgaste: float = 1.5

onready var animation: AnimationPlayer = $AnimationPlayer
onready var colision: CollisionShape2D = $CollisionShape2D 

var esta_activado: bool = false setget, get_esta_activado

# Setters y Getters
func get_esta_activado() -> bool:
	return esta_activado

# Metodos

func _ready() -> void:
	set_process(false)
	controlar_colisionador(true)
	
	

func _process(delta: float) -> void:
	energia -= radio_desgaste * delta
	
	if energia <= 0.0:
		desactivar()
	

# Metodos Custom

func controlar_colisionador(is_disabled: bool) -> void:
	colision.set_deferred("disabled", is_disabled)

func activar() -> void:
	if energia <= 0.0:
		return
	esta_activado = true
	controlar_colisionador(false)
	animation.play("activando")

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	animation.play_backwards("activando")
	$AudioStreamPlayer.stop()
# Seniales internas

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and esta_activado:
		animation.play("activado")
		set_process(true)


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	
	

func _on_body_entered(body: Node) -> void:
	body.queue_free()
