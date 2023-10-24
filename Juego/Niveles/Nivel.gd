class_name Nivel

extends Node2D

export var explosion: PackedScene = null
export var explosion_meteor: PackedScene = null
export var meteorito: PackedScene = null
export var sector_meteoritos: PackedScene = null
export var tiempo_transicion_camara: float = 0.2

## Atributos Onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos: Node
onready var contenedor_sec_meteor: Node
onready var camara_nivel:Camera2D = $CameraNivel

## Metodos

func _ready() -> void:
	conectar_seniales()
	crear_contenedores()
	
## Metodos Custom

func conectar_seniales () -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawn_meteorito", self, "_on_spawn_meteorito")
	Eventos.connect("destruccion_meteor",self,"_on_destruccion_meteor")
	Eventos.connect("nave_en_sector_peligro",self, "_on_nave_en_sector_peligro")
	
	
func crear_contenedores () -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	contenedor_sec_meteor = Node.new()
	contenedor_sec_meteor.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sec_meteor)
	
func _on_disparo (proyectil: Proyectil) -> void:
	contenedor_proyectiles.add_child (proyectil)

func _on_nave_destruida(posicion: Vector2, num_explosiones: int) ->void:
	for _i in range(num_explosiones):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6),"timeout")


func _on_spawn_meteorito(pos_spawn: Vector2, dir_meteorito: Vector2, tamanio: float) ->void:
	var new_meteorito: Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)


func _on_destruccion_meteor(posicion: Vector2) ->void:
	var new_explosion: ExplosionMeteorito = explosion_meteor.instance()
	new_explosion.global_position = posicion
	add_child(new_explosion)
	
func _on_nave_en_sector_peligro(centro_cam: Vector2, tipo_peligro:String, num_peligros:int) ->void:
	if tipo_peligro == "Meteorito":
		_crear_sector_meteoritos(centro_cam, num_peligros)
	elif tipo_peligro == "Enemigo":
		pass
	
func _crear_sector_meteoritos(centro_cam: Vector2, num_peligros: int) ->void:
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.contr_sector(centro_cam, num_peligros)
	camara_nivel.global_position = centro_cam
	camara_nivel.current = true
	contenedor_sec_meteor.add_child(new_sector_meteoritos)

func transicion_camaras(desde: Vector2, hasta:Vector2, camara_actual: Camera2D) ->void:
	$TweenCamera.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion_camara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamera.start()
