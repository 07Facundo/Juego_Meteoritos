class_name SectorMeteoritos

extends Node2D

signal body_entered()

export var cantidad_meteoritos:int = 16

export var intervalo_spawn:float = 1.2

var spawners: Array


# Metodos
func _ready() -> void:
	$SpawnTimer.wait_time = intervalo_spawn
	almacenar_spawners()
	conectar_seniales_detectores()
	$TimerControlMeteoritos.start()

func conectar_seniales_detectores() ->void:
	for detector in $DetectorFueraDeZona.get_children():
		detector.connect("body_entered", self, "_on_detector_body_entered")
		
	
func almacenar_spawners() ->void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)
		
func spawner_aleatorio() ->int:
	randomize()
	return randi() % spawners.size()

func contr_sector(posicion: Vector2, cant_meteor: int) -> void:
	global_position = posicion
	cantidad_meteoritos = cant_meteor
	
# Seniales Internas
func _on_SpawnTimer_timeout() -> void:
	spawners[spawner_aleatorio()].spawnear_meteorito()


func _on_detector_body_entered(body: Node) ->void:
	if body is Meteorito:
		body.set_esta_en_sector(false)
	if body is EnemigoInterceptor:
		DatosJuego.set_enem_esta_sector(true)


func _on_TimerControlMeteoritos_timeout() -> void:
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		$TimerControlMeteoritos.stop()
		return
	cantidad_meteoritos -= 1
	print(cantidad_meteoritos)
