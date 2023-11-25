extends Node

var player_actual:Player = null setget set_player_actual, get_player_actual
var pers_enem_interc_activado: bool = false setget set_pers_enem_interc_activado
var enem_esta_sector:bool = false setget set_enem_esta_sector


func _ready() -> void:
	Eventos.connect("nave_destruida",self, "_on_nave_destruida")

func set_player_actual(player: Player) ->void:
	player_actual = player
	
func get_player_actual() ->Player:
	return player_actual

func _on_nave_destruida(nave:NaveBase, _posicion, _explosiones) ->void:
	if nave is Player:
		player_actual = null

func set_pers_enem_interc_activado(valor: bool) ->void:
	pers_enem_interc_activado = valor

func set_enem_esta_sector(valor:bool) ->void:
	enem_esta_sector = valor
