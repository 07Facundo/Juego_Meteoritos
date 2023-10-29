class_name SectorMeteoritos

extends Node2D

signal body_entered()

export var cantidad_meteoritos:int = 10
export var intervalo_spawn:float = 1.2

var spawners: Array


# Metodos
func _ready() -> void:
	$SpawnTimer.wait_time = intervalo_spawn
	almacenar_spawners()
	conectar_seniales_detectores()

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
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		return
	spawners[spawner_aleatorio()].spawnear_meteorito()
	cantidad_meteoritos -= 1
	cantidad_meteoritos += 1
	
	

func _on_detector_body_entered(body: Node) ->void:
	body.set_esta_en_sector(false)


		
		



