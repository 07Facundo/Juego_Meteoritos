class_name Meteorito

extends RigidBody2D

## Atributos Export
export var vel_lineal_base: Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base: float = 3.0
export var hitpoints_base: float = 10.0


onready var animation: AnimationPlayer = $AnimationPlayer


## Metodos
func _ready() -> void:
	angular_velocity = vel_ang_base


## Atributos
var hitpoints: float

## Constructor
func crear(pos: Vector2, dir: Vector2, tamanio: float) -> void:
	position = pos
#Calcular Masa, tamaño de Sprite y de Colisionador 
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
#radio = diametro / 2
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision: CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision 
#Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad() 
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
#Calcular hitpoints
	hitpoints = hitpoints_base * tamanio
#Solo Debug
	print("hitpoints: ", hitpoints)


func recibir_danio(danio: float) -> void:
	if hitpoints <= 0.0:
		destruir()
	else:
		hitpoints -= danio
	animation.play("impacto")
	
		
func destruir() ->void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("destruccion_meteor", global_position)
	queue_free()


func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1, 2.1)
