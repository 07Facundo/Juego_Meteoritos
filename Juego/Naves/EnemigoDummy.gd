extends Node2D

var hitpoints: float = 10.0


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	$Canion.set_esta_disparando(true)

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()

func recibir_danio(danio: float) -> void:
	if hitpoints <= 0.0:
		Eventos.emit_signal("nave_destruida", global_position, 3)
		queue_free()
	else:
		hitpoints -= danio
